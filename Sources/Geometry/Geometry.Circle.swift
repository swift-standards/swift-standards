// Circle.swift
// A circle defined by center and radius.

extension Geometry {
    /// A circle in 2D space defined by its center and radius.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let circle = Geometry<Double>.Circle(
    ///     center: .init(x: 100, y: 100),
    ///     radius: 50
    /// )
    /// print(circle.area)           // ~7853.98
    /// print(circle.circumference)  // ~314.16
    /// ```
    public struct Circle {
        /// The center point of the circle
        public var center: Point<2>

        /// The radius of the circle
        public var radius: Length

        /// Create a circle with the given center and radius
        @inlinable
        public init(center: consuming Point<2>, radius: consuming Length) {
            self.center = center
            self.radius = radius
        }
    }
}

extension Geometry.Circle: Sendable where Scalar: Sendable {}
extension Geometry.Circle: Equatable where Scalar: Equatable {}
extension Geometry.Circle: Hashable where Scalar: Hashable {}

// MARK: - Codable

extension Geometry.Circle: Codable where Scalar: Codable {}

// MARK: - Convenience Initializers

extension Geometry.Circle {
    /// Create a circle with center at origin and given radius
    @inlinable
    public init(radius: Geometry.Length) where Scalar: AdditiveArithmetic {
        self.init(center: .zero, radius: radius)
    }
}

// MARK: - Properties (FloatingPoint)

extension Geometry.Circle where Scalar: FloatingPoint {
    /// The diameter of the circle (2 * radius)
    @inlinable
    public var diameter: Geometry.Length {
        let two: Scalar = Scalar(2)
        return Geometry.Length(radius.value * two)
    }

    /// The circumference of the circle (2 * π * radius)
    @inlinable
    public var circumference: Scalar {
        let two: Scalar = Scalar(2)
        let r: Scalar = radius.value
        return two * Scalar.pi * r
    }

    /// The area of the circle (π * radius²)
    @inlinable
    public var area: Scalar {
        let r: Scalar = radius.value
        return Scalar.pi * r * r
    }

    /// The bounding rectangle of the circle
    @inlinable
    public var boundingBox: Geometry.Rectangle {
        let r: Scalar = radius.value
        let cx: Scalar = center.x.value
        let cy: Scalar = center.y.value
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
    /// Check if a point is inside or on the circle.
    ///
    /// - Parameter point: The point to test
    /// - Returns: `true` if the point is inside or on the circle boundary
    @inlinable
    public func contains(_ point: Geometry.Point<2>) -> Bool {
        let distSq: Scalar = center.distanceSquared(to: point)
        let r: Scalar = radius.value
        return distSq <= r * r
    }

    /// Check if a point is strictly inside the circle (not on boundary).
    ///
    /// - Parameter point: The point to test
    /// - Returns: `true` if the point is strictly inside the circle
    @inlinable
    public func containsInterior(_ point: Geometry.Point<2>) -> Bool {
        let distSq: Scalar = center.distanceSquared(to: point)
        let r: Scalar = radius.value
        return distSq < r * r
    }

    /// Check if this circle contains another circle entirely.
    ///
    /// - Parameter other: The circle to test
    /// - Returns: `true` if `other` is entirely inside this circle
    @inlinable
    public func contains(_ other: Self) -> Bool {
        let dist: Scalar = center.distance(to: other.center)
        return dist + other.radius.value <= radius.value
    }
}

// MARK: - Point on Circle (BinaryFloatingPoint)

extension Geometry.Circle where Scalar: BinaryFloatingPoint {
    /// Get the point on the circle at the given angle (measured from positive x-axis).
    ///
    /// - Parameter angle: The angle in radians
    /// - Returns: The point on the circle at that angle
    @inlinable
    public func point(at angle: Radian) -> Geometry.Point<2> {
        let c: Scalar = Scalar(angle.cos)
        let s: Scalar = Scalar(angle.sin)
        let r: Scalar = radius.value
        let cx: Scalar = center.x.value
        let cy: Scalar = center.y.value
        return Geometry.Point(
            x: Geometry.X(cx + r * c),
            y: Geometry.Y(cy + r * s)
        )
    }

    /// Get the closest point on the circle to a given point.
    ///
    /// - Parameter point: The external point
    /// - Returns: The closest point on the circle boundary
    @inlinable
    public func closestPoint(to point: Geometry.Point<2>) -> Geometry.Point<2> {
        let v: Geometry.Vector<2> = Geometry.Vector(dx: point.x - center.x, dy: point.y - center.y)
        let len: Scalar = v.length
        let zero: Scalar = Scalar(0)
        let r: Scalar = radius.value
        let cx: Scalar = center.x.value
        let cy: Scalar = center.y.value
        guard len > zero else {
            // Point is at center, return any point on circle
            return Geometry.Point(
                x: Geometry.X(cx + r),
                y: center.y
            )
        }
        let scale: Scalar = r / len
        let vdx: Scalar = v.dx.value
        let vdy: Scalar = v.dy.value
        return Geometry.Point(
            x: Geometry.X(cx + vdx * scale),
            y: Geometry.Y(cy + vdy * scale)
        )
    }
}

// MARK: - Intersection (FloatingPoint)

extension Geometry.Circle where Scalar: FloatingPoint {
    /// Check if this circle intersects another circle.
    ///
    /// - Parameter other: The other circle
    /// - Returns: `true` if circles intersect or touch
    @inlinable
    public func intersects(_ other: Self) -> Bool {
        let dist: Scalar = center.distance(to: other.center)
        let sumRadii: Scalar = radius.value + other.radius.value
        let diffRadii: Scalar = abs(radius.value - other.radius.value)
        return dist <= sumRadii && dist >= diffRadii
    }

    /// Find intersection points with a line.
    ///
    /// - Parameter line: The line to intersect with
    /// - Returns: Array of 0, 1, or 2 intersection points
    @inlinable
    public func intersection(with line: Geometry.Line) -> [Geometry.Point<2>] {
        // Vector from line point to center
        let cx: Scalar = center.x.value
        let cy: Scalar = center.y.value
        let lpx: Scalar = line.point.x.value
        let lpy: Scalar = line.point.y.value
        let fx: Scalar = lpx - cx
        let fy: Scalar = lpy - cy
        let dx: Scalar = line.direction.dx.value
        let dy: Scalar = line.direction.dy.value
        let r: Scalar = radius.value

        // Quadratic equation coefficients: at² + bt + c = 0
        let a: Scalar = dx * dx + dy * dy
        let two: Scalar = Scalar(2)
        let four: Scalar = Scalar(4)
        let b: Scalar = two * (fx * dx + fy * dy)
        let c: Scalar = fx * fx + fy * fy - r * r

        let discriminant: Scalar = b * b - four * a * c
        let zero: Scalar = Scalar(0)

        guard discriminant >= zero else { return [] }

        if discriminant == zero {
            // Tangent line - one intersection
            let t: Scalar = -b / (two * a)
            return [line.point(at: t)]
        }

        // Two intersections
        let sqrtDisc: Scalar = discriminant.squareRoot()
        let t1: Scalar = (-b - sqrtDisc) / (two * a)
        let t2: Scalar = (-b + sqrtDisc) / (two * a)
        return [line.point(at: t1), line.point(at: t2)]
    }

    /// Find intersection points with another circle.
    ///
    /// - Parameter other: The other circle
    /// - Returns: Array of 0, 1, or 2 intersection points
    @inlinable
    public func intersection(with other: Self) -> [Geometry.Point<2>] {
        let d: Scalar = center.distance(to: other.center)
        let r1: Scalar = radius.value
        let r2: Scalar = other.radius.value
        let zero: Scalar = Scalar(0)
        let two: Scalar = Scalar(2)

        // No intersection if circles are too far apart or one contains the other
        guard d <= r1 + r2 && d >= abs(r1 - r2) && d > zero else {
            if d == zero && r1 == r2 {
                // Coincident circles - infinite intersections, return empty
                return []
            }
            return []
        }

        // Distance from center to the line connecting intersection points
        let a: Scalar = (r1 * r1 - r2 * r2 + d * d) / (two * d)
        let hSq: Scalar = r1 * r1 - a * a

        // Handle numerical precision for tangent case
        guard hSq >= zero else { return [] }
        let h: Scalar = hSq.squareRoot()

        // Point P2 on the line between centers
        let cx: Scalar = center.x.value
        let cy: Scalar = center.y.value
        let ocx: Scalar = other.center.x.value
        let ocy: Scalar = other.center.y.value
        let dx: Scalar = (ocx - cx) / d
        let dy: Scalar = (ocy - cy) / d
        let px: Scalar = cx + a * dx
        let py: Scalar = cy + a * dy

        if h == zero {
            // Tangent circles - one intersection
            return [Geometry.Point(x: Geometry.X(px), y: Geometry.Y(py))]
        }

        // Two intersections
        return [
            Geometry.Point(
                x: Geometry.X(px + h * dy),
                y: Geometry.Y(py - h * dx)
            ),
            Geometry.Point(
                x: Geometry.X(px - h * dy),
                y: Geometry.Y(py + h * dx)
            )
        ]
    }
}

// MARK: - Transformation (FloatingPoint)

extension Geometry.Circle where Scalar: FloatingPoint {
    /// Return a circle translated by the given vector.
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        Self(center: center + vector, radius: radius)
    }

    /// Return a circle scaled uniformly about its center.
    @inlinable
    public func scaled(by factor: Scalar) -> Self {
        Self(center: center, radius: Geometry.Length(radius.value * factor))
    }

    /// Return a circle scaled uniformly about a given point.
    @inlinable
    public func scaled(by factor: Scalar, about point: Geometry.Point<2>) -> Self {
        let px: Scalar = point.x.value
        let py: Scalar = point.y.value
        let cx: Scalar = center.x.value
        let cy: Scalar = center.y.value
        let newCenter: Geometry.Point<2> = Geometry.Point(
            x: Geometry.X(px + factor * (cx - px)),
            y: Geometry.Y(py + factor * (cy - py))
        )
        return Self(center: newCenter, radius: Geometry.Length(radius.value * factor))
    }
}

// MARK: - Functorial Map

extension Geometry.Circle {
    /// Create a circle by transforming the coordinates of another circle
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Circle, _ transform: (U) -> Scalar) {
        self.init(
            center: Geometry.Point<2>(other.center, transform),
            radius: Geometry.Length(other.radius, transform)
        )
    }

    /// Transform coordinates using the given closure
    @inlinable
    public func map<Result>(
        _ transform: (Scalar) -> Result
    ) -> Geometry<Result>.Circle {
        Geometry<Result>.Circle(
            center: center.map(transform),
            radius: radius.map(transform)
        )
    }
}
