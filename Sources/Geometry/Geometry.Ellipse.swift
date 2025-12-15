// Ellipse.swift
// An ellipse defined by center, semi-axes, and rotation.

public import Affine
public import Algebra
public import Algebra_Linear
public import Dimension
public import Dimension
public import RealModule

extension Geometry {
    /// An ellipse in 2D space defined by center, semi-axes, and rotation.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let ellipse = Geometry<Double, Void>.Ellipse(
    ///     center: .init(x: 0, y: 0),
    ///     semiMajor: 10,
    ///     semiMinor: 5,
    ///     rotation: .zero
    /// )
    /// print(ellipse.area)  // ~157.08
    /// ```
    public struct Ellipse {
        /// The center of the ellipse
        public var center: Point<2>

        /// The semi-major axis length (larger radius)
        public var semiMajor: Length

        /// The semi-minor axis length (smaller radius)
        public var semiMinor: Length

        /// The rotation angle (counter-clockwise from x-axis to major axis)
        public var rotation: Radian<Scalar>

        /// Create an ellipse with center, semi-axes, and rotation
        @inlinable
        public init(
            center: consuming Point<2>,
            semiMajor: consuming Length,
            semiMinor: consuming Length,
            rotation: consuming Radian<Scalar>
        ) {
            self.center = center
            self.semiMajor = semiMajor
            self.semiMinor = semiMinor
            self.rotation = rotation
        }
    }
}

extension Geometry.Ellipse: Sendable where Scalar: Sendable {}
extension Geometry.Ellipse: Equatable where Scalar: Equatable {}
extension Geometry.Ellipse: Hashable where Scalar: Hashable {}

// MARK: - Codable
#if Codable
    extension Geometry.Ellipse: Codable where Scalar: Codable {}
#endif
// MARK: - Convenience Initializers

extension Geometry.Ellipse where Scalar: AdditiveArithmetic {
    /// Create an axis-aligned ellipse centered at the origin
    @inlinable
    public init(
        semiMajor: Geometry.Length,
        semiMinor: Geometry.Length
    ) {
        self.init(center: .zero, semiMajor: semiMajor, semiMinor: semiMinor, rotation: .zero)
    }

    /// Create an axis-aligned ellipse (rotation defaults to zero)
    @inlinable
    public init(
        center: Geometry.Point<2>,
        semiMajor: Geometry.Length,
        semiMinor: Geometry.Length
    ) {
        self.init(center: center, semiMajor: semiMajor, semiMinor: semiMinor, rotation: Radian(Scalar.zero))
    }
}

extension Geometry.Ellipse where Scalar: FloatingPoint {
    /// Create a circle as a special case of ellipse
    @inlinable
    public static func circle(center: Geometry.Point<2>, radius: Geometry.Radius) -> Self {
        Self(center: center, semiMajor: radius, semiMinor: radius, rotation: Radian(0))
    }
}

// MARK: - Geometric Properties (FloatingPoint)

extension Geometry.Ellipse where Scalar: FloatingPoint {
    /// The major axis length (2 * semiMajor)
    @inlinable
    public var majorAxis: Geometry.Length {
        semiMajor * 2
    }

    /// The minor axis length (2 * semiMinor)
    @inlinable
    public var minorAxis: Geometry.Length {
        semiMinor * 2
    }

    /// The eccentricity of the ellipse (0 = circle, approaching 1 = more elongated)
    ///
    /// Returns a dimensionless `Scale<1>` since eccentricity is a ratio.
    @inlinable
    public var eccentricity: Scale<1, Scalar> {
        // Typed: Length × Length → Area
        let aSq = semiMajor * semiMajor
        let bSq = semiMinor * semiMinor
        // Area - Area → Area, Area / Area → Scale<1>, sqrt(Scale<1>) → Scale<1>
        return sqrt((aSq - bSq) / aSq)
    }

    /// The linear eccentricity (distance from center to focus)
    @inlinable
    public var focalDistance: Geometry.Distance {
        // semiMajor * semiMajor returns Area (Measure<2, Space>)
        // sqrt(Area) returns Magnitude (Length)
        let aSq = semiMajor * semiMajor
        let bSq = semiMinor * semiMinor
        return sqrt(aSq - bSq)
    }
}

// MARK: - Foci (Real & BinaryFloatingPoint)

extension Geometry.Ellipse where Scalar: Real & BinaryFloatingPoint {
    /// The two foci of the ellipse
    @inlinable
    public var foci: (f1: Geometry.Point<2>, f2: Geometry.Point<2>) {
        let c: Scalar = focalDistance._rawValue
        let cosVal: Scalar = rotation.cos.value
        let sinVal: Scalar = rotation.sin.value

        let dx: Scalar = c * cosVal
        let dy: Scalar = c * sinVal

        return (
            Geometry.Point(
                x: center.x - Geometry.Width(dx),
                y: center.y - Geometry.Height(dy)
            ),
            Geometry.Point(
                x: center.x + Geometry.Width(dx),
                y: center.y + Geometry.Height(dy)
            )
        )
    }
}

// MARK: - Area and Perimeter (FloatingPoint)

extension Geometry.Ellipse where Scalar: FloatingPoint {
    /// The area of the ellipse (π * a * b)
    @inlinable
    public var area: Scalar { Geometry.area(of: self) }

    /// The approximate perimeter using Ramanujan's approximation
    ///
    /// Uses raw scalar math for the Ramanujan h-term calculation since it involves
    /// dimensionless ratios and transcendental operations that don't benefit from type tracking.
    @inlinable
    public var perimeter: Geometry.Perimeter {
        let a: Scalar = semiMajor._rawValue
        let b: Scalar = semiMinor._rawValue
        let diff: Scalar = a - b
        let sum: Scalar = a + b
        let h: Scalar = (diff * diff) / (sum * sum)
        let sqrtTerm: Scalar = (4 - 3 * h).squareRoot()
        let hTerm: Scalar = 3 * h / (10 + sqrtTerm)
        let factor: Scalar = 1 + hTerm
        let perimeter: Scalar = Scalar.pi * sum * factor
        return Geometry.Length(perimeter)
    }

    /// Whether this ellipse is actually a circle (semi-major equals semi-minor)
    @inlinable
    public var isCircle: Bool {
        semiMajor == semiMinor
    }
}

// MARK: - Point on Ellipse (Real & BinaryFloatingPoint)

extension Geometry.Ellipse where Scalar: Real & BinaryFloatingPoint {
    /// Get a point on the ellipse at parameter t.
    ///
    /// - Parameter t: The parameter angle in radians (not the actual angle from center)
    /// - Returns: The point on the ellipse
    @inlinable
    public func point(at t: Radian<Scalar>) -> Geometry.Point<2> {
        Geometry.point(of: self, at: t)
    }

    /// Get the tangent vector at parameter t.
    ///
    /// - Parameter t: The parameter angle in radians
    /// - Returns: The tangent vector (not normalized)
    @inlinable
    public func tangent(at t: Radian<Scalar>) -> Geometry.Vector<2> {
        let cosT: Scalar = t.cos.value
        let sinT: Scalar = t.sin.value
        let a: Scalar = semiMajor._rawValue
        let b: Scalar = semiMinor._rawValue

        // Derivative of point on unrotated ellipse
        let dx: Scalar = -a * sinT
        let dy: Scalar = b * cosT

        // Rotate by ellipse rotation
        let cosR: Scalar = rotation.cos.value
        let sinR: Scalar = rotation.sin.value

        return Geometry.Vector(
            dx: Linear<Scalar, Space>.Dx(dx * cosR - dy * sinR),
            dy: Linear<Scalar, Space>.Dy(dx * sinR + dy * cosR)
        )
    }
}

// MARK: - Containment (Real & BinaryFloatingPoint)

extension Geometry.Ellipse where Scalar: Real & BinaryFloatingPoint {
    /// Check if a point is inside or on the ellipse.
    ///
    /// - Parameter point: The point to test
    /// - Returns: `true` if the point is inside or on the ellipse boundary
    @inlinable
    public func contains(_ point: Geometry.Point<2>) -> Bool {
        Geometry.contains(self, point: point)
    }
}

// MARK: - Bounding Box (Real & BinaryFloatingPoint)

extension Geometry.Ellipse where Scalar: Real & BinaryFloatingPoint {
    /// The axis-aligned bounding box of the ellipse
    @inlinable
    public var boundingBox: Geometry.Rectangle {
        // Typed area calculations: Length × Length → Area
        let aSq = semiMajor * semiMajor
        let bSq = semiMinor * semiMinor

        // Typed scale calculations: Scale × Scale → Scale
        let cosSq = rotation.cos * rotation.cos
        let sinSq = rotation.sin * rotation.sin

        // Half-extents: sqrt(Area × Scale + Area × Scale) → Magnitude
        // Area × Scale → Area, Area + Area → Area, sqrt(Area) → Magnitude
        let halfWidth: Geometry.Length = sqrt(aSq * cosSq + bSq * sinSq)
        let halfHeight: Geometry.Length = sqrt(aSq * sinSq + bSq * cosSq)

        // Coordinate ± Magnitude → Coordinate
        return Geometry.Rectangle(
            llx: center.x - halfWidth,
            lly: center.y - halfHeight,
            urx: center.x + halfWidth,
            ury: center.y + halfHeight
        )
    }
}

// MARK: - Circle Conversion (FloatingPoint)

extension Geometry.Ellipse where Scalar: FloatingPoint {
    /// Create an ellipse from a circle.
    ///
    /// The resulting ellipse has equal semi-major and semi-minor axes
    /// equal to the circle's radius, with zero rotation.
    @inlinable
    public init(_ circle: Geometry.Circle) {
        self.init(
            center: circle.center,
            semiMajor: circle.radius,
            semiMinor: circle.radius,
            rotation: .zero
        )
    }
}

// MARK: - Transformation (FloatingPoint)

extension Geometry.Ellipse where Scalar: FloatingPoint {
    /// Return an ellipse translated by the given vector.
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        Self(
            center: center + vector,
            semiMajor: semiMajor,
            semiMinor: semiMinor,
            rotation: rotation
        )
    }

    /// Return an ellipse scaled uniformly about its center.
    @inlinable
    public func scaled(by factor: Scale<1, Scalar>) -> Self {
        Self(
            center: center,
            semiMajor: semiMajor * factor,
            semiMinor: semiMinor * factor,
            rotation: rotation
        )
    }

    /// Return an ellipse rotated about its center.
    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        Self(
            center: center,
            semiMajor: semiMajor,
            semiMinor: semiMinor,
            rotation: rotation + angle
        )
    }
}

// MARK: - Ellipse Static Implementations

extension Geometry where Scalar: FloatingPoint {
    /// Calculate the area of an ellipse (π × a × b).
    @inlinable
    public static func area(of ellipse: Ellipse) -> Scalar {
        let a: Scalar = ellipse.semiMajor._rawValue
        let b: Scalar = ellipse.semiMinor._rawValue
        return Scalar.pi * a * b
    }
}

extension Geometry where Scalar: Real & BinaryFloatingPoint {
    /// Check if an ellipse contains a point.
    @inlinable
    public static func contains(_ ellipse: Ellipse, point: Point<2>) -> Bool {
        // Transform point to ellipse-local coordinates
        let dx: Scalar = point.x._rawValue - ellipse.center.x._rawValue
        let dy: Scalar = point.y._rawValue - ellipse.center.y._rawValue

        // Rotate by -rotation to align with axes
        let cosR: Scalar = ellipse.rotation.cos.value
        let sinR: Scalar = ellipse.rotation.sin.value
        let localX: Scalar = dx * cosR + dy * sinR
        let localY: Scalar = -dx * sinR + dy * cosR

        // Check ellipse equation: (x/a)² + (y/b)² ≤ 1
        let a: Scalar = ellipse.semiMajor._rawValue
        let b: Scalar = ellipse.semiMinor._rawValue
        let aSq: Scalar = a * a
        let bSq: Scalar = b * b
        let one: Scalar = 1
        return (localX * localX) / aSq + (localY * localY) / bSq <= one
    }

    /// Get a point on an ellipse at parameter t.
    @inlinable
    public static func point(of ellipse: Ellipse, at t: Radian<Scalar>) -> Point<2> {
        let cosT: Scalar = t.cos.value
        let sinT: Scalar = t.sin.value
        let a: Scalar = ellipse.semiMajor._rawValue
        let b: Scalar = ellipse.semiMinor._rawValue

        // Point on unrotated ellipse
        let x: Scalar = a * cosT
        let y: Scalar = b * sinT

        // Rotate by ellipse rotation
        let cosR: Scalar = ellipse.rotation.cos.value
        let sinR: Scalar = ellipse.rotation.sin.value

        let cx: Scalar = ellipse.center.x._rawValue
        let cy: Scalar = ellipse.center.y._rawValue

        return Point(
            x: Affine<Scalar, Space>.X(cx + x * cosR - y * sinR),
            y: Affine<Scalar, Space>.Y(cy + x * sinR + y * cosR)
        )
    }
}

// MARK: - Functorial Map

extension Geometry.Ellipse {
    /// Create an ellipse by transforming the coordinates of another ellipse
    @inlinable
    public init<U>(
        _ other: borrowing Geometry<U, Space>.Ellipse,
        _ transform: (U) throws -> Scalar
    ) rethrows {
        self.init(
            center: try Affine<Scalar, Space>.Point<2>(other.center, transform),
            semiMajor: try other.semiMajor.map(transform),
            semiMinor: try other.semiMinor.map(transform),
            rotation: Radian(try transform(other.rotation._rawValue))
        )
    }

    /// Transform coordinates using the given closure
    @inlinable
    public func map<Result>(
        _ transform: (Scalar) throws -> Result
    ) rethrows -> Geometry<Result, Space>.Ellipse {
        .init(
            center: try center.map(transform),
            semiMajor: try semiMajor.map(transform),
            semiMinor: try semiMinor.map(transform),
            rotation: Radian(try transform(rotation._rawValue))
        )
    }
}
