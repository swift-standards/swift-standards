// Circle.swift
// A circle defined by center and radius, parameterized by coordinate space.

public import Affine
public import Algebra_Linear
public import Angle
public import Dimension

extension Geometry {
    /// Circle in 2D space defined by center and radius.
    ///
    /// Use for circular shapes, collision detection, and geometric calculations involving circles.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let circle = Geometry<Double, Void>.Circle(
    ///     center: .init(x: .init(100), y: .init(100)),
    ///     radius: .init(50)
    /// )
    /// print(circle.area)           // 7853.98...
    /// print(circle.circumference)  // 314.16...
    /// ```
    public struct Circle {
        /// Center point.
        public var center: Point<2>

        /// Radius (distance from center to edge).
        public var radius: Radius

        /// Creates a circle with the given center and radius.
        @inlinable
        public init(center: consuming Point<2>, radius: consuming Radius) {
            self.center = center
            self.radius = radius
        }
    }
}

extension Geometry.Circle: Sendable where Scalar: Sendable {}
extension Geometry.Circle: Equatable where Scalar: Equatable {}
extension Geometry.Circle: Hashable where Scalar: Hashable {}

// MARK: - Codable
#if Codable
    extension Geometry.Circle: Codable where Scalar: Codable {}
#endif

// MARK: - Convenience Initializers

extension Geometry.Circle {
    /// Creates a circle centered at origin with given radius.
    @inlinable
    public init(radius: Geometry.Radius) where Scalar: AdditiveArithmetic {
        self.init(center: .zero, radius: radius)
    }
}

// MARK: - Circle from Ellipse

extension Geometry.Circle where Scalar: FloatingPoint {
    /// Creates a circle from an ellipse if the ellipse is circular.
    ///
    /// - Parameter ellipse: The ellipse to convert.
    /// - Returns: A circle if the ellipse has equal semi-major and semi-minor axes, `nil` otherwise.
    @inlinable
    public init?(_ ellipse: Geometry.Ellipse) {
        let diff: Scalar = ellipse.semiMajor.value - ellipse.semiMinor.value
        guard abs(diff) < Scalar.ulpOfOne else { return nil }
        self.init(center: ellipse.center, radius: ellipse.semiMajor)
    }
}

// MARK: - Static Properties

extension Geometry.Circle where Scalar: ExpressibleByIntegerLiteral & AdditiveArithmetic {
    /// Unit circle centered at origin with radius 1.
    @inlinable
    public static var unit: Self {
        Self(center: .zero, radius: .init(1))
    }
}

// MARK: - Properties (FloatingPoint)

extension Geometry.Circle where Scalar: FloatingPoint {
    /// Diameter (2 × radius).
    @inlinable
    public var diameter: Geometry.Magnitude {
        Geometry.Magnitude(radius * 2)
    }

    /// Circumference (2π × radius).
    @inlinable
    public var circumference: Geometry.Circumference {
        radius * (2 * Scalar.pi)
    }

    /// Area (π × radius²).
    @inlinable
    public var area: Scalar {
        Scalar.pi * radius.value * radius.value
    }

    /// Axis-aligned bounding rectangle.
    @inlinable
    public var boundingBox: Geometry.Rectangle {
        let r = radius.value
        let cx = center.x.value
        let cy = center.y.value
        return Geometry.Rectangle(
            llx: Geometry.X(cx - r),
            lly: Geometry.Y(cy - r),
            urx: Geometry.X(cx + r),
            ury: Geometry.Y(cy + r)
        )
    }
}

// MARK: - Containment (FloatingPoint)

extension Geometry.Circle where Scalar: FloatingPoint {
    /// Checks if point is inside or on the circle boundary.
    @inlinable
    public func contains(_ point: Geometry.Point<2>) -> Bool {
        center.distanceSquared(to: point) <= radius.value * radius.value
    }

    /// Checks if point is strictly inside (not on boundary).
    @inlinable
    public func containsInterior(_ point: Geometry.Point<2>) -> Bool {
        center.distanceSquared(to: point) < radius.value * radius.value
    }

    /// Checks if another circle is entirely contained within this circle.
    @inlinable
    public func contains(_ other: Self) -> Bool {
        center.distance(to: other.center) + other.radius <= radius
    }
}

// MARK: - Point on Circle (BinaryFloatingPoint)

extension Geometry.Circle where Scalar: BinaryFloatingPoint {
    /// Returns point on circle at given angle from positive x-axis.
    @inlinable
    public func point(at angle: Radian) -> Geometry.Point<2> {
        let c = Scalar(angle.cos)
        let s = Scalar(angle.sin)
        let r = radius.value
        return Geometry.Point(
            x: Affine<Scalar, Space>.X(center.x.value + r * c),
            y: Affine<Scalar, Space>.Y(center.y.value + r * s)
        )
    }

    /// Returns unit tangent vector at given angle (perpendicular to radius, counter-clockwise).
    @inlinable
    public func tangent(at angle: Radian) -> Geometry.Vector<2> {
        let c = Scalar(angle.cos)
        let s = Scalar(angle.sin)
        return Geometry.Vector(
            dx: Linear<Scalar, Space>.Dx(-s),
            dy: Linear<Scalar, Space>.Dy(c)
        )
    }

    /// Returns closest point on circle boundary to given point.
    @inlinable
    public func closestPoint(to point: Geometry.Point<2>) -> Geometry.Point<2> {
        let vx = point.x.value - center.x.value
        let vy = point.y.value - center.y.value
        let len = (vx * vx + vy * vy).squareRoot()
        let r = radius.value
        guard len > 0 else {
            // Point is at center, return any point on circle
            return Geometry.Point(
                x: Affine<Scalar, Space>.X(center.x.value + r),
                y: center.y
            )
        }
        let scale = r / len
        return Geometry.Point(
            x: Affine<Scalar, Space>.X(center.x.value + vx * scale),
            y: Affine<Scalar, Space>.Y(center.y.value + vy * scale)
        )
    }
}

// MARK: - Intersection (FloatingPoint)

extension Geometry.Circle where Scalar: FloatingPoint {
    /// Checks if circles intersect or touch.
    @inlinable
    public func intersects(_ other: Self) -> Bool {
        let dist = center.distance(to: other.center)
        let sumRadii = radius + other.radius
        let diffRadii = radius >= other.radius ? radius - other.radius : other.radius - radius
        return dist <= sumRadii && dist >= diffRadii
    }

    /// Finds intersection points with a line.
    ///
    /// - Returns: Array of 0, 1, or 2 points where line crosses circle.
    @inlinable
    public func intersection(with line: Geometry.Line) -> [Geometry.Point<2>] {
        let fx = line.point.x.value - center.x.value
        let fy = line.point.y.value - center.y.value
        let dx = line.direction.dx.value
        let dy = line.direction.dy.value
        let r = radius.value

        // Quadratic equation: at² + bt + c = 0
        let a = dx * dx + dy * dy
        let b = 2 * (fx * dx + fy * dy)
        let c = fx * fx + fy * fy - r * r

        let discriminant = b * b - 4 * a * c

        guard discriminant >= 0 else { return [] }

        if discriminant == 0 {
            let t = -b / (2 * a)
            return [line.point(at: t)]
        }

        let sqrtDisc = discriminant.squareRoot()
        let t1 = (-b - sqrtDisc) / (2 * a)
        let t2 = (-b + sqrtDisc) / (2 * a)
        return [line.point(at: t1), line.point(at: t2)]
    }

    /// Finds intersection points with another circle.
    ///
    /// - Returns: Array of 0, 1, or 2 points where circles intersect.
    @inlinable
    public func intersection(with other: Self) -> [Geometry.Point<2>] {
        let dist = center.distance(to: other.center)
        let sumRadii = radius + other.radius
        let diffRadii = radius >= other.radius ? radius - other.radius : other.radius - radius

        guard dist <= sumRadii && dist >= diffRadii && dist.value > 0 else {
            return []
        }

        // Complex geometric formula - use raw values for intermediate calculations
        let d = dist.value
        let r1 = radius.value
        let r2 = other.radius.value

        let a = (r1 * r1 - r2 * r2 + d * d) / (2 * d)
        let hSq = r1 * r1 - a * a

        guard hSq >= 0 else { return [] }
        let h = hSq.squareRoot()

        let cx = center.x.value
        let cy = center.y.value
        let ocx = other.center.x.value
        let ocy = other.center.y.value
        let dirX = (ocx - cx) / d
        let dirY = (ocy - cy) / d
        let px = cx + a * dirX
        let py = cy + a * dirY

        if h == 0 {
            return [Geometry.Point(x: Affine<Scalar, Space>.X(px), y: Affine<Scalar, Space>.Y(py))]
        }

        return [
            Geometry.Point(
                x: Affine<Scalar, Space>.X(px + h * dirY),
                y: Affine<Scalar, Space>.Y(py - h * dirX)
            ),
            Geometry.Point(
                x: Affine<Scalar, Space>.X(px - h * dirY),
                y: Affine<Scalar, Space>.Y(py + h * dirX)
            ),
        ]
    }
}

// MARK: - Transformation (FloatingPoint)

extension Geometry.Circle where Scalar: FloatingPoint {
    /// Returns circle translated by vector.
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        Self(center: center + vector, radius: radius)
    }

    /// Returns circle scaled uniformly about its center.
    @inlinable
    public func scaled(by factor: Scalar) -> Self {
        Self(center: center, radius: radius * factor)
    }

    /// Returns circle scaled uniformly about given point.
    @inlinable
    public func scaled(by factor: Scalar, about point: Geometry.Point<2>) -> Self {
        let px = point.x.value
        let py = point.y.value
        let cx = center.x.value
        let cy = center.y.value
        let newCenter = Geometry.Point(
            x: Affine<Scalar, Space>.X(px + factor * (cx - px)),
            y: Affine<Scalar, Space>.Y(py + factor * (cy - py))
        )
        return Self(center: newCenter, radius: radius * factor)
    }
}

// MARK: - Functorial Map

extension Geometry.Circle {
    /// Creates circle by transforming coordinates of another circle.
    @inlinable
    public init<U>(
        _ other: borrowing Geometry<U, Space>.Circle,
        _ transform: (U) throws -> Scalar
    ) rethrows {
        self.init(
            center: try Geometry.Point<2>(other.center, transform),
            radius: try other.radius.map(transform)
        )
    }

    /// Transforms coordinates using the given closure.
    @inlinable
    public func map<Result>(
        _ transform: (Scalar) throws -> Result
    ) rethrows -> Geometry<Result, Space>.Circle {
        Geometry<Result, Space>.Circle(
            center: try center.map(transform),
            radius: try radius.map(transform)
        )
    }
}

// MARK: - Bézier Approximation

extension Geometry.Circle where Scalar: BinaryFloatingPoint {
    /// Cubic Bézier curve segment.
    public struct BezierSegment {
        /// Start point.
        public let start: Geometry.Point<2>
        /// First control point.
        public let control1: Geometry.Point<2>
        /// Second control point.
        public let control2: Geometry.Point<2>
        /// End point.
        public let end: Geometry.Point<2>

        /// Creates a Bézier segment with given control points.
        @inlinable
        public init(
            start: Geometry.Point<2>,
            control1: Geometry.Point<2>,
            control2: Geometry.Point<2>,
            end: Geometry.Point<2>
        ) {
            self.start = start
            self.control1 = control1
            self.control2 = control2
            self.end = end
        }
    }
}

extension Geometry.Circle.BezierSegment: Sendable where Scalar: Sendable {}

extension Geometry.Circle where Scalar: BinaryFloatingPoint {
    /// Four cubic Bézier curves approximating this circle.
    ///
    /// Uses standard constant k = 0.5522847498 for excellent circle approximation.
    /// Curves start at 3 o'clock and proceed counter-clockwise through quadrants.
    @inlinable
    public var bezierCurves: [BezierSegment] {
        let k = Scalar(0.5522847498) * radius.value
        let cx = center.x.value
        let cy = center.y.value
        let r = radius.value

        // Cardinal points
        let right = Geometry.Point<2>(x: .init(cx + r), y: .init(cy))
        let bottom = Geometry.Point<2>(x: .init(cx), y: .init(cy - r))
        let left = Geometry.Point<2>(x: .init(cx - r), y: .init(cy))
        let top = Geometry.Point<2>(x: .init(cx), y: .init(cy + r))

        return [
            BezierSegment(
                start: right,
                control1: Geometry.Point<2>(x: .init(cx + r), y: .init(cy - k)),
                control2: Geometry.Point<2>(x: .init(cx + k), y: .init(cy - r)),
                end: bottom
            ),
            BezierSegment(
                start: bottom,
                control1: Geometry.Point<2>(x: .init(cx - k), y: .init(cy - r)),
                control2: Geometry.Point<2>(x: .init(cx - r), y: .init(cy - k)),
                end: left
            ),
            BezierSegment(
                start: left,
                control1: Geometry.Point<2>(x: .init(cx - r), y: .init(cy + k)),
                control2: Geometry.Point<2>(x: .init(cx - k), y: .init(cy + r)),
                end: top
            ),
            BezierSegment(
                start: top,
                control1: Geometry.Point<2>(x: .init(cx + k), y: .init(cy + r)),
                control2: Geometry.Point<2>(x: .init(cx + r), y: .init(cy + k)),
                end: right
            ),
        ]
    }

    /// Starting point for Bézier curve rendering (3 o'clock position).
    @inlinable
    public var bezierStartPoint: Geometry.Point<2> {
        Geometry.Point<2>(x: .init(center.x.value + radius.value), y: center.y)
    }
}
