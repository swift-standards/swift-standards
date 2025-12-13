// Arc.swift
// A circular arc defined by center, radius, and angle range.

public import Affine
public import Algebra
public import Algebra_Linear
public import Angle
public import RealModule

extension Geometry {
    /// A circular arc in 2D space.
    ///
    /// An arc is a portion of a circle defined by center, radius, and angle range.
    /// Angles are measured counter-clockwise from the positive x-axis.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Quarter circle arc
    /// let arc = Geometry<Double, Void>.Arc(
    ///     center: .init(x: 0, y: 0),
    ///     radius: 10,
    ///     startAngle: .zero,
    ///     endAngle: .pi / 2
    /// )
    /// print(arc.length)  // ~15.71 (quarter of circumference)
    /// ```
    public struct Arc {
        /// The center of the arc's circle
        public var center: Point<2>

        /// The radius of the arc
        public var radius: Radius

        /// The starting angle (from positive x-axis, counter-clockwise)
        public var startAngle: Radian<Scalar>

        /// The ending angle (from positive x-axis, counter-clockwise)
        public var endAngle: Radian<Scalar>

        /// Create an arc with center, radius, and angle range
        @inlinable
        public init(
            center: consuming Point<2>,
            radius: consuming Radius,
            startAngle: consuming Radian<Scalar>,
            endAngle: consuming Radian<Scalar>
        ) {
            self.center = center
            self.radius = radius
            self.startAngle = startAngle
            self.endAngle = endAngle
        }
    }
}

extension Geometry.Arc: Sendable where Scalar: Sendable {}
extension Geometry.Arc: Equatable where Scalar: Equatable {}
extension Geometry.Arc: Hashable where Scalar: Hashable {}

// MARK: - Codable
#if Codable
    extension Geometry.Arc: Codable where Scalar: Codable {}
#endif
// MARK: - Factory Methods

extension Geometry.Arc where Scalar: BinaryFloatingPoint {
    /// Create a semicircle arc
    @inlinable
    public static func semicircle(
        center: Geometry.Point<2>,
        radius: Geometry.Radius,
        startAngle: Radian<Scalar> = .zero
    ) -> Self {
        Self(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: startAngle + .pi
        )
    }
}

extension Geometry.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Create a full circle arc
    @inlinable
    public static func fullCircle(center: Geometry.Point<2>, radius: Geometry.Radius) -> Self {
        Self(
            center: center,
            radius: radius,
            startAngle: .zero,
            endAngle: .twoPi
        )
    }

    /// Create a quarter circle arc
    @inlinable
    public static func quarterCircle(
        center: Geometry.Point<2>,
        radius: Geometry.Radius,
        startAngle: Radian<Scalar> = .zero
    ) -> Self {
        Self(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: startAngle + .halfPi
        )
    }
}

// MARK: - Angle Properties

extension Geometry.Arc where Scalar: AdditiveArithmetic & Comparable {
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

extension Geometry.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Whether this arc represents a full circle or more
    @inlinable
    public var isFullCircle: Bool {
        abs(sweep) >= Radian.twoPi
    }
}

// MARK: - Endpoints (Real & BinaryFloatingPoint)

extension Geometry.Arc where Scalar: Real & BinaryFloatingPoint {
    /// The starting point of the arc
    @inlinable
    public var startPoint: Geometry.Point<2> {
        // center + radius * cos/sin: Coordinate + Magnitude * Scale = Coordinate
        Geometry.Point(
            x: center.x + radius * startAngle.cos,
            y: center.y + radius * startAngle.sin
        )
    }

    /// The ending point of the arc
    @inlinable
    public var endPoint: Geometry.Point<2> {
        Geometry.Point(
            x: center.x + radius * endAngle.cos,
            y: center.y + radius * endAngle.sin
        )
    }

    /// The midpoint of the arc
    @inlinable
    public var midPoint: Geometry.Point<2> {
        let midAngle = (startAngle + endAngle) / 2
        return Geometry.Point(
            x: center.x + radius * midAngle.cos,
            y: center.y + radius * midAngle.sin
        )
    }
}

// MARK: - Point on Arc (Real & BinaryFloatingPoint)

extension Geometry.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Get a point on the arc at parameter t.
    ///
    /// - Parameter t: Parameter in [0, 1] (0 = start, 1 = end)
    /// - Returns: The point on the arc at that parameter
    @inlinable
    public func point(at t: Scalar) -> Geometry.Point<2> {
        let angle = startAngle + t * sweep
        return Geometry.Point(
            x: center.x + radius * angle.cos,
            y: center.y + radius * angle.sin
        )
    }

    /// Get the tangent direction at parameter t.
    ///
    /// - Parameter t: Parameter in [0, 1]
    /// - Returns: The unit tangent vector
    @inlinable
    public func tangent(at t: Scalar) -> Geometry.Vector<2> {
        let angle = startAngle + t * sweep
        // Tangent is perpendicular to radius, in direction of sweep
        let sign: Scalar = sweep._rawValue >= 0 ? 1 : -1
        return Geometry.Vector(
            dx: Linear<Scalar, Space>.Dx(-sign * angle.sin.value),
            dy: Linear<Scalar, Space>.Dy(sign * angle.cos.value)
        )
    }
}

// MARK: - Length (Real & BinaryFloatingPoint)

extension Geometry.Arc where Scalar: Real & BinaryFloatingPoint {
    /// The arc length
    ///
    /// Formula: s = r × θ where θ is the angle in radians (dimensionless).
    @inlinable
    public var length: Geometry.ArcLength {
        // Radians are dimensionless, so we use the raw value for the multiplication
        radius * abs(sweep._rawValue)
    }
}

// MARK: - Bounding Box (Real & BinaryFloatingPoint)

extension Geometry.Arc where Scalar: Real & BinaryFloatingPoint {
    /// The axis-aligned bounding box of the arc
    @inlinable
    public var boundingBox: Geometry.Rectangle { Geometry.boundingBox(of: self) }
}

// MARK: - Static Implementations

extension Geometry where Scalar: Real & BinaryFloatingPoint {
    /// Calculate the axis-aligned bounding box of an arc.
    ///
    /// Note: Bounding box calculations inherently mix coordinate components,
    /// requiring raw scalar arithmetic similar to matrix transforms.
    @inlinable
    public static func boundingBox(of arc: Arc) -> Rectangle {
        let cx = arc.center.x._rawValue
        let cy = arc.center.y._rawValue
        let r = arc.radius._rawValue

        // Special case for full circle or more
        if arc.isFullCircle {
            return Rectangle(
                llx: X(cx - r),
                lly: Y(cy - r),
                urx: X(cx + r),
                ury: Y(cy + r)
            )
        }

        var minX = min(arc.startPoint.x._rawValue, arc.endPoint.x._rawValue)
        var maxX = max(arc.startPoint.x._rawValue, arc.endPoint.x._rawValue)
        var minY = min(arc.startPoint.y._rawValue, arc.endPoint.y._rawValue)
        var maxY = max(arc.startPoint.y._rawValue, arc.endPoint.y._rawValue)

        // Check if arc crosses cardinal directions
        let start = arc.startAngle.normalized
        let end = arc.endAngle.normalized
        let sweep = arc.sweep._rawValue

        func containsAngle(_ angle: Radian<Scalar>) -> Bool {
            let a = angle._rawValue
            let s = start._rawValue
            let e = end._rawValue
            if sweep >= 0 {
                if s <= e {
                    return a >= s && a <= e
                } else {
                    return a >= s || a <= e
                }
            } else {
                if s >= e {
                    return a <= s && a >= e
                } else {
                    return a <= s || a >= e
                }
            }
        }

        // Right (0°)
        if containsAngle(Radian<Scalar>.zero) {
            maxX = max(maxX, cx + r)
        }
        // Top (90°)
        if containsAngle(Radian<Scalar>.halfPi) {
            maxY = max(maxY, cy + r)
        }
        // Left (180°)
        if containsAngle(Radian(Scalar.pi)) {
            minX = min(minX, cx - r)
        }
        // Bottom (270°)
        if containsAngle(Radian(Scalar.pi * 1.5)) {
            minY = min(minY, cy - r)
        }

        return Rectangle(
            llx: X(minX),
            lly: Y(minY),
            urx: X(maxX),
            ury: Y(maxY)
        )
    }
}

// MARK: - Containment (Real & BinaryFloatingPoint)

extension Geometry.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Check if a point lies on the arc.
    ///
    /// - Parameter point: The point to test
    /// - Returns: `true` if the point is on the arc (within tolerance)
    @inlinable
    public func contains(_ point: Geometry.Point<2>) -> Bool {
        // Check if point is at correct distance from center
        let dist = center.distance(to: point)
        guard abs(dist._rawValue - radius._rawValue) < Scalar.ulpOfOne * 100 else { return false }

        // Check if point's angle is within the arc
        let dx = point.x - center.x
        let dy = point.y - center.y
        let pointAngle: Radian<Scalar> = Radian.atan2(y: dy, x: dx)

        return angleIsInArc(pointAngle)
    }

    /// Check if an angle falls within the arc's range
    @inlinable
    internal func angleIsInArc(_ angle: Radian<Scalar>) -> Bool {
        let normAngle = angle.normalized
        let normStart = startAngle.normalized
        let normEnd = endAngle.normalized

        if sweep >= 0 {
            if normStart <= normEnd {
                return normAngle >= normStart && normAngle <= normEnd
            } else {
                return normAngle >= normStart || normAngle <= normEnd
            }
        } else {
            if normStart >= normEnd {
                return normAngle <= normStart && normAngle >= normEnd
            } else {
                return normAngle <= normStart || normAngle >= normEnd
            }
        }
    }
}

// MARK: - Array of Beziers from Arc

extension Array {
    /// Create an array of cubic Bezier curves approximating an arc.
    ///
    /// Uses the standard approximation where each Bezier spans at most 90°.
    ///
    /// - Parameter arc: The arc to approximate
    @inlinable
    public init<Scalar: Real & BinaryFloatingPoint, Space>(
        arc: Geometry<Scalar, Space>.Arc
    ) where Element == Geometry<Scalar, Space>.Bezier {
        let sweepRaw = arc.sweep._rawValue
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
            let bezier = Self.arcSegmentToBezier(
                arc: arc,
                from: currentAngle,
                to: nextAngle
            )
            beziers.append(bezier)

            currentAngle = nextAngle
        }

        self = beziers
    }

    /// Convert a single arc segment (≤90°) to a cubic Bezier
    ///
    /// Note: Bezier control point calculations inherently mix coordinate components,
    /// requiring raw scalar arithmetic.
    @inlinable
    internal static func arcSegmentToBezier<
        Scalar: Real & BinaryFloatingPoint,
        Space
    >(
        arc: Geometry<Scalar, Space>.Arc,
        from startAngle: Radian<Scalar>,
        to endAngle: Radian<Scalar>
    ) -> Geometry<Scalar, Space>.Bezier where Element == Geometry<Scalar, Space>.Bezier {
        let sweepRaw = (endAngle - startAngle)._rawValue
        let halfSweepRaw = sweepRaw / 2

        // Control point distance factor: k = (4/3) * tan(θ/2)
        let k = Scalar(4.0 / 3.0) * Scalar.tan(halfSweepRaw / 2)

        // Extract raw values for arithmetic
        let cx = arc.center.x._rawValue
        let cy = arc.center.y._rawValue
        let r = arc.radius._rawValue

        // Start and end points
        let cosStart = startAngle.cos.value
        let sinStart = startAngle.sin.value
        let cosEnd = endAngle.cos.value
        let sinEnd = endAngle.sin.value

        let p0x = cx + r * cosStart
        let p0y = cy + r * sinStart
        let p3x = cx + r * cosEnd
        let p3y = cy + r * sinEnd

        // Tangent directions at start and end (perpendicular to radius)
        let t0x = -sinStart
        let t0y = cosStart
        let t1x = -sinEnd
        let t1y = cosEnd

        // Control points
        let p1x = p0x + k * r * t0x
        let p1y = p0y + k * r * t0y
        let p2x = p3x - k * r * t1x
        let p2y = p3y - k * r * t1y

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

// MARK: - Transformation (Real & BinaryFloatingPoint)

extension Geometry.Arc where Scalar: Real & BinaryFloatingPoint {
    /// Return an arc translated by the given vector.
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        Self(center: center + vector, radius: radius, startAngle: startAngle, endAngle: endAngle)
    }

    /// Return an arc scaled uniformly about its center.
    @inlinable
    public func scaled(by factor: Scale<1, Scalar>) -> Self {
        Self(
            center: center,
            radius: radius * factor.value,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }

    /// Return the arc with reversed direction.
    @inlinable
    public var reversed: Self {
        Self(center: center, radius: radius, startAngle: endAngle, endAngle: startAngle)
    }
}

// MARK: - Functorial Map

extension Geometry.Arc {
    /// Create an arc by transforming the coordinates of another arc
    @inlinable
    public init<U>(
        _ other: borrowing Geometry<U, Space>.Arc,
        _ transform: (U) throws -> Scalar
    ) rethrows {
        self.init(
            center: try Affine<Scalar, Space>.Point<2>(other.center, transform),
            radius: try other.radius.map(transform),
            startAngle: try Radian(transform(other.startAngle._rawValue)),
            endAngle: try Radian(transform(other.endAngle._rawValue))
        )
    }

    /// Transform coordinates using the given closure
    @inlinable
    public func map<Result>(
        _ transform: (Scalar) throws -> Result
    ) rethrows -> Geometry<Result, Space>.Arc {
        .init(
            center: try center.map(transform),
            radius: try radius.map(transform),
            startAngle: try Radian(transform(startAngle._rawValue)),
            endAngle: try Radian(transform(endAngle._rawValue))
        )
    }
}
