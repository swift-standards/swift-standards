// Ellipse.swift
// An ellipse defined by center, semi-axes, and rotation.

public import Affine
import Algebra
public import Algebra_Linear
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
#if !hasFeature(Embedded)
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
        self.init(
            center: center,
            semiMajor: semiMajor,
            semiMinor: semiMinor,
            rotation: Radian(Scalar.zero)
        )
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
        let c: Scalar = focalDistance._storage
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

extension Geometry.Ellipse where Scalar: BinaryFloatingPoint {
    /// The area of the ellipse (π * a * b)
    @inlinable
    public var area: Geometry.Area { Geometry.area(of: self) }
}

extension Geometry.Ellipse where Scalar: FloatingPoint {

    /// The approximate perimeter using Ramanujan's approximation
    ///
    /// Uses raw scalar math for the Ramanujan h-term calculation since it involves
    /// dimensionless ratios and transcendental operations that don't benefit from type tracking.
    @inlinable
    public var perimeter: Geometry.Perimeter {
        let a: Scalar = semiMajor._storage
        let b: Scalar = semiMinor._storage
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
        let a: Scalar = semiMajor._storage
        let b: Scalar = semiMinor._storage

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

extension Geometry where Scalar: BinaryFloatingPoint {
    /// Calculate the area of an ellipse (π × a × b).
    @inlinable
    public static func area(of ellipse: Ellipse) -> Area {
        Scale<1, Scalar>.pi * ellipse.semiMajor * ellipse.semiMinor
    }
}

extension Geometry where Scalar: Real & BinaryFloatingPoint {
    /// Check if an ellipse contains a point.
    @inlinable
    public static func contains(_ ellipse: Ellipse, point: Point<2>) -> Bool {
        // Transform point to ellipse-local coordinates
        let dx: Scalar = point.x._storage - ellipse.center.x._storage
        let dy: Scalar = point.y._storage - ellipse.center.y._storage

        // Rotate by -rotation to align with axes
        let cosR: Scalar = ellipse.rotation.cos.value
        let sinR: Scalar = ellipse.rotation.sin.value
        let localX: Scalar = dx * cosR + dy * sinR
        let localY: Scalar = -dx * sinR + dy * cosR

        // Check ellipse equation: (x/a)² + (y/b)² ≤ 1
        let a: Scalar = ellipse.semiMajor._storage
        let b: Scalar = ellipse.semiMinor._storage
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
        let a: Scalar = ellipse.semiMajor._storage
        let b: Scalar = ellipse.semiMinor._storage

        // Point on unrotated ellipse
        let x: Scalar = a * cosT
        let y: Scalar = b * sinT

        // Rotate by ellipse rotation
        let cosR: Scalar = ellipse.rotation.cos.value
        let sinR: Scalar = ellipse.rotation.sin.value

        let cx: Scalar = ellipse.center.x._storage
        let cy: Scalar = ellipse.center.y._storage

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
            rotation: Radian(try transform(other.rotation._storage))
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
            rotation: Radian(try transform(rotation._storage))
        )
    }
}

// MARK: - Ellipse.Arc

extension Geometry.Ellipse {
    /// An arc (portion) of an ellipse.
    ///
    /// An elliptical arc is defined by the parent ellipse parameters (center, semi-axes, rotation)
    /// plus the start and end angles that define the portion of the ellipse.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let arc = Geometry<Double, Void>.Ellipse.Arc(
    ///     center: .init(x: 0, y: 0),
    ///     semiMajor: 10,
    ///     semiMinor: 5,
    ///     rotation: .zero,
    ///     startAngle: .zero,
    ///     endAngle: .pi
    /// )
    /// print(arc.sweep)  // π radians (half ellipse)
    /// ```
    public struct Arc {
        /// The center of the parent ellipse
        public var center: Geometry.Point<2>

        /// The semi-major axis length (larger radius)
        public var semiMajor: Geometry.Length

        /// The semi-minor axis length (smaller radius)
        public var semiMinor: Geometry.Length

        /// The rotation angle of the ellipse (counter-clockwise from x-axis to major axis)
        public var rotation: Radian<Scalar>

        /// The starting angle (parameter angle, not geometric angle)
        public var startAngle: Radian<Scalar>

        /// The ending angle (parameter angle, not geometric angle)
        public var endAngle: Radian<Scalar>

        /// Create an elliptical arc with center, semi-axes, rotation, and angle range
        @inlinable
        public init(
            center: consuming Geometry.Point<2>,
            semiMajor: consuming Geometry.Length,
            semiMinor: consuming Geometry.Length,
            rotation: consuming Radian<Scalar>,
            startAngle: consuming Radian<Scalar>,
            endAngle: consuming Radian<Scalar>
        ) {
            self.center = center
            self.semiMajor = semiMajor
            self.semiMinor = semiMinor
            self.rotation = rotation
            self.startAngle = startAngle
            self.endAngle = endAngle
        }
    }
}

extension Geometry.Ellipse.Arc: Sendable where Scalar: Sendable {}
extension Geometry.Ellipse.Arc: Equatable where Scalar: Equatable {}
extension Geometry.Ellipse.Arc: Hashable where Scalar: Hashable {}

// MARK: - Ellipse.Arc Codable
#if !hasFeature(Embedded)
    extension Geometry.Ellipse.Arc: Codable where Scalar: Codable {}
#endif

// MARK: - Ellipse.Arc Angle Properties

extension Geometry.Ellipse.Arc where Scalar: AdditiveArithmetic & Comparable {
    /// The angular span of the arc
    @inlinable
    public var sweep: Radian<Scalar> {
        endAngle - startAngle
    }

    /// Whether this arc sweeps counter-clockwise (positive sweep)
    @inlinable
    public var isCounterClockwise: Bool {
        sweep > .zero
    }
}

extension Geometry.Ellipse.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Whether this arc represents a full ellipse or more
    @inlinable
    public var isFullEllipse: Bool {
        abs(sweep) >= Radian.twoPi
    }
}

// MARK: - Ellipse.Arc Endpoints

extension Geometry.Ellipse.Arc where Scalar: Real & BinaryFloatingPoint {
    /// The starting point of the arc
    @inlinable
    public var startPoint: Geometry.Point<2> {
        point(at: Scale(0))
    }

    /// The ending point of the arc
    @inlinable
    public var endPoint: Geometry.Point<2> {
        point(at: Scale(1))
    }

    /// The midpoint of the arc
    @inlinable
    public var midPoint: Geometry.Point<2> {
        point(at: Scale(0.5))
    }
}

// MARK: - Ellipse.Arc Point Evaluation

extension Geometry.Ellipse.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Get a point on the arc at parameter t.
    ///
    /// - Parameter t: Parameter in [0, 1] (0 = start, 1 = end)
    /// - Returns: The point on the arc at that parameter
    @inlinable
    public func point(at t: Scale<1, Scalar>) -> Geometry.Point<2> {
        let angle = startAngle + t * sweep
        return pointAtAngle(angle)
    }

    /// Get a point on the arc at a specific angle.
    ///
    /// Note: Rotation transforms inherently mix X and Y coordinates,
    /// requiring raw scalar arithmetic similar to matrix transforms.
    ///
    /// - Parameter angle: The parameter angle on the ellipse
    /// - Returns: The point on the ellipse at that angle
    @inlinable
    package func pointAtAngle(_ angle: Radian<Scalar>) -> Geometry.Point<2> {
        let cosT = angle.cos
        let sinT = angle.sin

        // Point on unrotated ellipse: (a·cos(t), b·sin(t))
        // Rotation mixes these, requiring raw arithmetic
        let a = semiMajor._storage
        let b = semiMinor._storage
        let x = a * cosT.value
        let y = b * sinT.value

        let cosR = rotation.cos
        let sinR = rotation.sin

        // Apply rotation and translate to center
        return Geometry.Point(
            x: center.x + Geometry.Width(x * cosR.value - y * sinR.value),
            y: center.y + Geometry.Height(x * sinR.value + y * cosR.value)
        )
    }

    /// Get the tangent direction at parameter t.
    ///
    /// Note: Rotation transforms inherently mix X and Y coordinates,
    /// requiring raw scalar arithmetic similar to matrix transforms.
    ///
    /// - Parameter t: Parameter in [0, 1]
    /// - Returns: The tangent vector (not normalized)
    @inlinable
    public func tangent(at t: Scale<1, Scalar>) -> Geometry.Vector<2> {
        let angle = startAngle + t * sweep
        let cosT = angle.cos
        let sinT = angle.sin

        // Derivative of point on unrotated ellipse: (-a·sin(t), b·cos(t))
        // Rotation mixes these, requiring raw arithmetic
        let a = semiMajor._storage
        let b = semiMinor._storage
        let dx = -a * sinT.value
        let dy = b * cosT.value

        let cosR = rotation.cos
        let sinR = rotation.sin

        // Direction sign from sweep
        let sign: Scalar = sweep._storage >= 0 ? 1 : -1

        return Geometry.Vector(
            dx: Geometry.Dx(sign * (dx * cosR.value - dy * sinR.value)),
            dy: Geometry.Dy(sign * (dx * sinR.value + dy * cosR.value))
        )
    }
}

// MARK: - Ellipse.Arc Length

extension Geometry.Ellipse.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Approximate arc length via numerical integration.
    ///
    /// Elliptical arc length requires elliptic integrals; we approximate
    /// by summing chord lengths over subdivisions.
    ///
    /// - Parameter segments: Number of subdivisions (default: 100)
    /// - Returns: The approximate arc length
    @inlinable
    public func length(segments: Int = 100) -> Geometry.ArcLength {
        guard segments > 0 else { return .zero }

        var total: Geometry.ArcLength = .zero
        var prev = startPoint

        for i in 1...segments {
            let t = Scale<1, Scalar>(Scalar(i) / Scalar(segments))
            let current = point(at: t)
            total += prev.distance(to: current)
            prev = current
        }

        return total
    }
}

// MARK: - Ellipse.Arc Bounding Box

extension Geometry.Ellipse.Arc where Scalar: Real & BinaryFloatingPoint {
    /// The axis-aligned bounding box of the arc.
    ///
    /// Note: Bounding box calculations inherently mix coordinate components,
    /// requiring raw scalar arithmetic similar to matrix transforms.
    @inlinable
    public var boundingBox: Geometry.Rectangle {
        // Full ellipse case
        if isFullEllipse {
            return Geometry.Ellipse(
                center: center,
                semiMajor: semiMajor,
                semiMinor: semiMinor,
                rotation: rotation
            ).boundingBox
        }

        // Start with endpoints
        let p0 = startPoint
        let p1 = endPoint

        var minX = min(p0.x._storage, p1.x._storage)
        var maxX = max(p0.x._storage, p1.x._storage)
        var minY = min(p0.y._storage, p1.y._storage)
        var maxY = max(p0.y._storage, p1.y._storage)

        // Check extrema: where dx/dt = 0 or dy/dt = 0
        // For rotated ellipse, extrema occur at specific parameter angles
        let a = semiMajor._storage
        let b = semiMinor._storage
        let phi = rotation._storage

        // X extrema: tan(t) = -(b/a)·tan(φ)
        let tanPhi = Scalar.tan(phi)
        let xExtremaAngle = Scalar.atan2(y: -b * tanPhi, x: a)

        // Y extrema: tan(t) = (b/a)·cot(φ) = (b/a)/tan(φ)
        let yExtremaAngle = Scalar.atan2(y: b, x: a * tanPhi)

        // Check each potential extremum angle
        for baseAngle in [xExtremaAngle, xExtremaAngle + .pi, yExtremaAngle, yExtremaAngle + .pi] {
            if containsAngle(Radian(baseAngle)) {
                let pt = pointAtAngle(Radian(baseAngle))
                minX = min(minX, pt.x._storage)
                maxX = max(maxX, pt.x._storage)
                minY = min(minY, pt.y._storage)
                maxY = max(maxY, pt.y._storage)
            }
        }

        return Geometry.Rectangle(
            llx: Geometry.X(minX),
            lly: Geometry.Y(minY),
            urx: Geometry.X(maxX),
            ury: Geometry.Y(maxY)
        )
    }

    /// Check if an angle falls within the arc's range.
    @inlinable
    package func containsAngle(_ angle: Radian<Scalar>) -> Bool {
        let a = angle._storage
        let s = startAngle._storage
        let e = endAngle._storage
        let sweepVal = sweep._storage

        // Normalize angle to [0, 2π)
        let twoPi = Scalar.pi * 2
        let normA = a - (a / twoPi).rounded(.down) * twoPi
        let normS = s - (s / twoPi).rounded(.down) * twoPi
        let normE = e - (e / twoPi).rounded(.down) * twoPi

        if sweepVal >= 0 {
            if normS <= normE {
                return normA >= normS && normA <= normE
            } else {
                return normA >= normS || normA <= normE
            }
        } else {
            if normS >= normE {
                return normA <= normS && normA >= normE
            } else {
                return normA <= normS || normA >= normE
            }
        }
    }
}

// MARK: - Ellipse.Arc Containment

extension Geometry.Ellipse.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Check if a point lies on the arc.
    ///
    /// - Parameter point: The point to test
    /// - Returns: `true` if the point is on the arc (within tolerance)
    @inlinable
    public func contains(_ point: Geometry.Point<2>) -> Bool {
        // First check if point is on the ellipse
        let dx = point.x._storage - center.x._storage
        let dy = point.y._storage - center.y._storage

        // Rotate to ellipse-local coordinates
        let cosR = rotation.cos.value
        let sinR = rotation.sin.value
        let localX = dx * cosR + dy * sinR
        let localY = -dx * sinR + dy * cosR

        // Check ellipse equation: (x/a)² + (y/b)² ≈ 1
        let a = semiMajor._storage
        let b = semiMinor._storage
        let aSq: Scalar = a * a
        let bSq: Scalar = b * b
        let xTerm: Scalar = (localX * localX) / aSq
        let yTerm: Scalar = (localY * localY) / bSq
        let ellipseVal: Scalar = xTerm + yTerm

        let tolerance: Scalar = Scalar.ulpOfOne * 1000
        guard abs(ellipseVal - 1) < tolerance else { return false }

        // Check if the angle is within the arc's range
        let pointAngle = Radian(Scalar.atan2(y: localY / b, x: localX / a))
        return containsAngle(pointAngle)
    }
}

// MARK: - Ellipse.Arc SVG Endpoint-to-Center Conversion

extension Geometry.Ellipse.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Create an elliptical arc from SVG endpoint parameterization.
    ///
    /// This implements the conversion algorithm from W3C SVG spec Appendix F.6.5.
    /// SVG arcs are specified by start point, end point, radii, rotation, and flags.
    ///
    /// - Parameters:
    ///   - start: The starting point of the arc (current point in path)
    ///   - end: The ending point of the arc
    ///   - rx: X-axis radius (will be scaled if too small)
    ///   - ry: Y-axis radius (will be scaled if too small)
    ///   - xAxisRotation: Rotation of the ellipse x-axis from the coordinate x-axis
    ///   - largeArcFlag: If true, choose the larger arc (> 180°)
    ///   - sweepFlag: If true, draw in positive angle direction (counter-clockwise in SVG coordinates)
    @inlinable
    public init(
        from start: Geometry.Point<2>,
        to end: Geometry.Point<2>,
        rx: Geometry.Length,
        ry: Geometry.Length,
        xAxisRotation: Radian<Scalar>,
        largeArcFlag: Bool,
        sweepFlag: Bool
    ) {
        // Handle degenerate case: coincident endpoints
        let x1 = start.x._storage
        let y1 = start.y._storage
        let x2 = end.x._storage
        let y2 = end.y._storage

        if x1 == x2 && y1 == y2 {
            // Degenerate: return zero-length arc at the point
            self.init(
                center: start,
                semiMajor: rx,
                semiMinor: ry,
                rotation: xAxisRotation,
                startAngle: .zero,
                endAngle: .zero
            )
            return
        }

        var rxVal = abs(rx._storage)
        var ryVal = abs(ry._storage)

        // Handle degenerate case: zero radii (treat as line)
        if rxVal == 0 || ryVal == 0 {
            // Degenerate: return a point at the midpoint
            let midX = (x1 + x2) / 2
            let midY = (y1 + y2) / 2
            self.init(
                center: Geometry.Point(x: Geometry.X(midX), y: Geometry.Y(midY)),
                semiMajor: Geometry.Length(rxVal),
                semiMinor: Geometry.Length(ryVal),
                rotation: xAxisRotation,
                startAngle: .zero,
                endAngle: .zero
            )
            return
        }

        let phi = xAxisRotation._storage
        let cosPhi = Scalar.cos(phi)
        let sinPhi = Scalar.sin(phi)

        // Step 1: Compute (x1', y1') - rotated midpoint vector
        let dx = (x1 - x2) / 2
        let dy = (y1 - y2) / 2
        let x1Prime = cosPhi * dx + sinPhi * dy
        let y1Prime = -sinPhi * dx + cosPhi * dy

        // Step 2: Correct radii if too small
        // Check: (x1'^2/rx^2) + (y1'^2/ry^2) <= 1
        let rxSqInit: Scalar = rxVal * rxVal
        let rySqInit: Scalar = ryVal * ryVal
        let lambdaX: Scalar = (x1Prime * x1Prime) / rxSqInit
        let lambdaY: Scalar = (y1Prime * y1Prime) / rySqInit
        let lambda: Scalar = lambdaX + lambdaY
        if lambda > 1 {
            let sqrtLambda = Scalar.sqrt(lambda)
            rxVal *= sqrtLambda
            ryVal *= sqrtLambda
        }

        // Step 3: Compute center in rotated coordinates (cx', cy')
        let rxSq: Scalar = rxVal * rxVal
        let rySq: Scalar = ryVal * ryVal
        let x1PrimeSq: Scalar = x1Prime * x1Prime
        let y1PrimeSq: Scalar = y1Prime * y1Prime

        let sqNumerator: Scalar = rxSq * rySq - rxSq * y1PrimeSq - rySq * x1PrimeSq
        let sqDenominator: Scalar = rxSq * y1PrimeSq + rySq * x1PrimeSq
        var sq: Scalar = sqNumerator / sqDenominator
        sq = max(0, sq)  // Clamp to avoid negative sqrt due to precision
        var sqrtVal: Scalar = Scalar.sqrt(sq)

        // Choose sign based on flags
        if largeArcFlag == sweepFlag {
            sqrtVal = -sqrtVal
        }

        let cxPrime: Scalar = sqrtVal * rxVal * y1Prime / ryVal
        let cyPrime: Scalar = sqrtVal * ryVal * x1Prime / rxVal * (-1)

        // Step 4: Compute center (cx, cy) in original coordinates
        let midX = (x1 + x2) / 2
        let midY = (y1 + y2) / 2
        let cx = cosPhi * cxPrime - sinPhi * cyPrime + midX
        let cy = sinPhi * cxPrime + cosPhi * cyPrime + midY

        // Step 5: Compute start angle θ1
        // θ1 = angle between (1, 0) and ((x1' - cx')/rx, (y1' - cy')/ry)
        let ux: Scalar = 1
        let uy: Scalar = 0
        let vx = (x1Prime - cxPrime) / rxVal
        let vy = (y1Prime - cyPrime) / ryVal

        let startAngleVal = Self.angleBetween(ux: ux, uy: uy, vx: vx, vy: vy)

        // Step 6: Compute sweep angle dθ
        // dθ = angle between ((x1' - cx')/rx, (y1' - cy')/ry) and ((-x1' - cx')/rx, (-y1' - cy')/ry)
        let wx = (-x1Prime - cxPrime) / rxVal
        let wy = (-y1Prime - cyPrime) / ryVal

        var dTheta = Self.angleBetween(ux: vx, uy: vy, vx: wx, vy: wy)

        // Adjust sweep based on sweep flag
        if !sweepFlag && dTheta > 0 {
            dTheta -= Scalar.pi * 2
        } else if sweepFlag && dTheta < 0 {
            dTheta += Scalar.pi * 2
        }

        let endAngleVal: Scalar = startAngleVal + dTheta
        self.init(
            center: Geometry.Point(x: Geometry.X(cx), y: Geometry.Y(cy)),
            semiMajor: Geometry.Length(rxVal),
            semiMinor: Geometry.Length(ryVal),
            rotation: xAxisRotation,
            startAngle: Radian(startAngleVal),
            endAngle: Radian(endAngleVal)
        )
    }

    /// Compute the angle between two vectors.
    @inlinable
    package static func angleBetween(ux: Scalar, uy: Scalar, vx: Scalar, vy: Scalar) -> Scalar {
        let dot = ux * vx + uy * vy
        let lenU = Scalar.sqrt(ux * ux + uy * uy)
        let lenV = Scalar.sqrt(vx * vx + vy * vy)
        var cosAngle = dot / (lenU * lenV)
        // Clamp to [-1, 1] to handle numerical precision issues
        cosAngle = max(-1, min(1, cosAngle))
        let angle = Scalar.acos(cosAngle)
        // Determine sign from cross product
        let cross = ux * vy - uy * vx
        return cross >= 0 ? angle : -angle
    }
}

// MARK: - Ellipse.Arc to Beziers

extension Array {
    /// Create an array of cubic Bezier curves approximating an elliptical arc.
    ///
    /// Uses the standard approximation where each Bezier spans at most 90°.
    ///
    /// Note: Bezier control point calculations inherently mix coordinate components,
    /// requiring raw scalar arithmetic similar to matrix transforms.
    ///
    /// - Parameter arc: The elliptical arc to approximate
    @inlinable
    public init<Scalar: Real & BinaryFloatingPoint, Space>(
        ellipticalArc arc: Geometry<Scalar, Space>.Ellipse.Arc
    ) where Element == Geometry<Scalar, Space>.Bezier {
        let sweepRaw = arc.sweep._storage
        guard abs(sweepRaw) > 0 else {
            self = []
            return
        }

        // Maximum angle per Bezier segment (90° = π/2)
        let maxAngle = Scalar.pi / 2

        // Number of segments needed
        let segmentCount = Int((abs(sweepRaw) / maxAngle).rounded(.up))
        let segmentAngle = sweepRaw / Scalar(segmentCount)

        var beziers: [Geometry<Scalar, Space>.Bezier] = []
        beziers.reserveCapacity(segmentCount)

        var currentAngle = arc.startAngle

        for _ in 0..<segmentCount {
            let nextAngle: Radian<Scalar> = currentAngle + Radian(segmentAngle)

            // Create Bezier for this segment
            let bezier = Self.ellipticalArcSegmentToBezier(
                arc: arc,
                from: currentAngle,
                to: nextAngle
            )
            beziers.append(bezier)

            currentAngle = nextAngle
        }

        self = beziers
    }

    /// Convert a single elliptical arc segment (≤90°) to a cubic Bezier.
    ///
    /// Note: Control point calculations inherently mix coordinate components,
    /// requiring raw scalar arithmetic similar to matrix transforms.
    @inlinable
    package static func ellipticalArcSegmentToBezier<
        Scalar: Real & BinaryFloatingPoint,
        Space
    >(
        arc: Geometry<Scalar, Space>.Ellipse.Arc,
        from startAngle: Radian<Scalar>,
        to endAngle: Radian<Scalar>
    ) -> Geometry<Scalar, Space>.Bezier where Element == Geometry<Scalar, Space>.Bezier {
        let sweepRaw = (endAngle - startAngle)._storage
        let halfSweepRaw = sweepRaw / 2

        // Control point distance factor: k = (4/3) * tan(θ/2)
        let k = Scalar(4.0 / 3.0) * Scalar.tan(halfSweepRaw / 2)

        // Extract raw values for the affine transformation
        let cx = arc.center.x._storage
        let cy = arc.center.y._storage
        let a = arc.semiMajor._storage
        let b = arc.semiMinor._storage
        let phi = arc.rotation._storage
        let cosPhi = Scalar.cos(phi)
        let sinPhi = Scalar.sin(phi)

        // Start and end points on unit circle (parameter space)
        let cosStart = Scalar.cos(startAngle._storage)
        let sinStart = Scalar.sin(startAngle._storage)
        let cosEnd = Scalar.cos(endAngle._storage)
        let sinEnd = Scalar.sin(endAngle._storage)

        // Transform from ellipse parameter space to world coordinates
        // Point on unrotated ellipse: (a·cos(t), b·sin(t))
        // Then rotate and translate

        // Start point
        let ux0 = a * cosStart
        let uy0 = b * sinStart
        let p0x = cx + ux0 * cosPhi - uy0 * sinPhi
        let p0y = cy + ux0 * sinPhi + uy0 * cosPhi

        // End point
        let ux3 = a * cosEnd
        let uy3 = b * sinEnd
        let p3x = cx + ux3 * cosPhi - uy3 * sinPhi
        let p3y = cy + ux3 * sinPhi + uy3 * cosPhi

        // Tangent directions at start and end (derivatives of ellipse parameterization)
        // d/dt (a·cos(t), b·sin(t)) = (-a·sin(t), b·cos(t))
        let t0x = -a * sinStart
        let t0y = b * cosStart
        let t1x = -a * sinEnd
        let t1y = b * cosEnd

        // Rotate tangents by ellipse rotation
        let rt0x = t0x * cosPhi - t0y * sinPhi
        let rt0y = t0x * sinPhi + t0y * cosPhi
        let rt1x = t1x * cosPhi - t1y * sinPhi
        let rt1y = t1x * sinPhi + t1y * cosPhi

        // Control points
        let p1x = p0x + k * rt0x
        let p1y = p0y + k * rt0y
        let p2x = p3x - k * rt1x
        let p2y = p3y - k * rt1y

        let p0 = Geometry<Scalar, Space>.Point(
            x: Geometry<Scalar, Space>.X(p0x),
            y: Geometry<Scalar, Space>.Y(p0y)
        )
        let p1 = Geometry<Scalar, Space>.Point(
            x: Geometry<Scalar, Space>.X(p1x),
            y: Geometry<Scalar, Space>.Y(p1y)
        )
        let p2 = Geometry<Scalar, Space>.Point(
            x: Geometry<Scalar, Space>.X(p2x),
            y: Geometry<Scalar, Space>.Y(p2y)
        )
        let p3 = Geometry<Scalar, Space>.Point(
            x: Geometry<Scalar, Space>.X(p3x),
            y: Geometry<Scalar, Space>.Y(p3y)
        )

        return .cubic(
            from: p0,
            control1: p1,
            control2: p2,
            to: p3
        )
    }
}

// MARK: - Ellipse.Arc Transformation

extension Geometry.Ellipse.Arc where Scalar: FloatingPoint {
    /// Return an arc translated by the given vector.
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        Self(
            center: center + vector,
            semiMajor: semiMajor,
            semiMinor: semiMinor,
            rotation: rotation,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }

    /// Return an arc scaled uniformly about its center.
    @inlinable
    public func scaled(by factor: Scale<1, Scalar>) -> Self {
        Self(
            center: center,
            semiMajor: semiMajor * factor,
            semiMinor: semiMinor * factor,
            rotation: rotation,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }

    /// Return the arc with reversed direction.
    @inlinable
    public var reversed: Self {
        Self(
            center: center,
            semiMajor: semiMajor,
            semiMinor: semiMinor,
            rotation: rotation,
            startAngle: endAngle,
            endAngle: startAngle
        )
    }
}

// MARK: - Ellipse.Arc Functorial Map

extension Geometry.Ellipse.Arc {
    /// Create an arc by transforming the coordinates of another arc.
    @inlinable
    public init<U>(
        _ other: borrowing Geometry<U, Space>.Ellipse.Arc,
        _ transform: (U) throws -> Scalar
    ) rethrows {
        self.init(
            center: try Affine<Scalar, Space>.Point<2>(other.center, transform),
            semiMajor: try other.semiMajor.map(transform),
            semiMinor: try other.semiMinor.map(transform),
            rotation: Radian(try transform(other.rotation._storage)),
            startAngle: Radian(try transform(other.startAngle._storage)),
            endAngle: Radian(try transform(other.endAngle._storage))
        )
    }

    /// Transform coordinates using the given closure.
    @inlinable
    public func map<Result>(
        _ transform: (Scalar) throws -> Result
    ) rethrows -> Geometry<Result, Space>.Ellipse.Arc {
        .init(
            center: try center.map(transform),
            semiMajor: try semiMajor.map(transform),
            semiMinor: try semiMinor.map(transform),
            rotation: Radian(try transform(rotation._storage)),
            startAngle: Radian(try transform(startAngle._storage)),
            endAngle: Radian(try transform(endAngle._storage))
        )
    }
}
