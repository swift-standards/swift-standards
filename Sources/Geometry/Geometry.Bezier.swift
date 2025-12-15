// Bezier.swift
// Bezier curves of arbitrary degree.

public import Affine
public import Algebra
public import Algebra_Linear
public import Dimension
public import RealModule

extension Geometry {
    /// A Bezier curve defined by control points.
    ///
    /// Supports curves of any degree:
    /// - Degree 1 (2 points): Linear
    /// - Degree 2 (3 points): Quadratic
    /// - Degree 3 (4 points): Cubic
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Cubic Bezier curve
    /// let curve = Geometry<Double, Void>.Bezier(controlPoints: [
    ///     .init(x: 0, y: 0),
    ///     .init(x: 1, y: 2),
    ///     .init(x: 3, y: 2),
    ///     .init(x: 4, y: 0)
    /// ])
    /// let midpoint = curve.point(at: 0.5)
    /// ```
    public struct Bezier {
        /// The control points defining the curve
        public var controlPoints: [Point<2>]

        /// Create a Bezier curve from control points
        @inlinable
        public init(controlPoints: consuming [Point<2>]) {
            self.controlPoints = controlPoints
        }
    }
}

extension Geometry.Bezier: Sendable where Scalar: Sendable {}
extension Geometry.Bezier: Equatable where Scalar: Equatable {}
extension Geometry.Bezier: Hashable where Scalar: Hashable {}

// MARK: - Codable
#if Codable
    extension Geometry.Bezier: Codable where Scalar: Codable {}
#endif
// MARK: - Basic Properties

extension Geometry.Bezier {
    /// The degree of the curve (number of control points - 1)
    @inlinable
    public var degree: Int { max(0, controlPoints.count - 1) }

    /// Whether this is a valid Bezier curve (at least 2 control points)
    @inlinable
    public var isValid: Bool { controlPoints.count >= 2 }

    /// The start point of the curve
    @inlinable
    public var startPoint: Geometry.Point<2>? { controlPoints.first }

    /// The end point of the curve
    @inlinable
    public var endPoint: Geometry.Point<2>? { controlPoints.last }
}

// MARK: - Convenience Initializers

extension Geometry.Bezier {
    /// Create a linear (degree 1) Bezier curve
    @inlinable
    public static func linear(
        from start: Geometry.Point<2>,
        to end: Geometry.Point<2>
    ) -> Self {
        Self(controlPoints: [start, end])
    }

    /// Create a quadratic (degree 2) Bezier curve
    @inlinable
    public static func quadratic(
        from start: Geometry.Point<2>,
        control: Geometry.Point<2>,
        to end: Geometry.Point<2>
    ) -> Self {
        Self(controlPoints: [start, control, end])
    }

    /// Create a cubic (degree 3) Bezier curve
    @inlinable
    public static func cubic(
        from start: Geometry.Point<2>,
        control1: Geometry.Point<2>,
        control2: Geometry.Point<2>,
        to end: Geometry.Point<2>
    ) -> Self {
        Self(controlPoints: [start, control1, control2, end])
    }
}

// MARK: - Evaluation (FloatingPoint)

extension Geometry.Bezier where Scalar: FloatingPoint {
    /// Evaluate the curve at parameter t using de Casteljau's algorithm.
    ///
    /// - Parameter t: Parameter in [0, 1] (0 = start, 1 = end)
    /// - Returns: The point on the curve at parameter t
    @inlinable
    public func point(at t: Scale<1, Scalar>) -> Geometry.Point<2>? {
        Geometry.point(of: self, at: t)
    }

    /// Evaluate the derivative (tangent vector) at parameter t.
    ///
    /// - Parameter t: Parameter in [0, 1]
    /// - Returns: The tangent vector at parameter t, or nil if curve is invalid
    @inlinable
    public func derivative(at t: Scale<1, Scalar>) -> Geometry.Vector<2>? {
        Geometry.derivative(of: self, at: t)
    }

    /// Get the tangent direction (normalized) at parameter t.
    ///
    /// - Parameter t: Parameter in [0, 1]
    /// - Returns: The unit tangent vector, or nil if tangent is zero
    @inlinable
    public func tangent(at t: Scale<1, Scalar>) -> Geometry.Vector<2>? {
        guard let d = derivative(at: t) else { return nil }
        let normalized = Linear<Scalar, Space>.Vector.normalized(d)
        guard normalized.length > 0 else { return nil }
        return normalized
    }

    /// Get the normal direction (perpendicular to tangent) at parameter t.
    ///
    /// - Parameter t: Parameter in [0, 1]
    /// - Returns: The unit normal vector (rotated 90° CCW from tangent)
    @inlinable
    public func normal(at t: Scale<1, Scalar>) -> Geometry.Vector<2>? {
        guard let tang = tangent(at: t) else { return nil }
        // Rotate 90° counter-clockwise
        return Geometry.Vector(
            dx: Linear<Scalar, Space>.Dx(-tang.dy._rawValue),
            dy: Linear<Scalar, Space>.Dy(tang.dx._rawValue)
        )
    }
}

// MARK: - Subdivision (FloatingPoint)

extension Geometry.Bezier where Scalar: FloatingPoint {
    /// Split the curve at parameter t into two curves.
    ///
    /// Uses de Casteljau's algorithm to compute the split.
    ///
    /// - Parameter t: Parameter in [0, 1] where to split
    /// - Returns: Tuple of (left curve, right curve), or nil if invalid
    @inlinable
    public func split(at t: Scale<1, Scalar>) -> (left: Self, right: Self)? {
        guard isValid else { return nil }

        var leftPoints: [Geometry.Point<2>] = []
        var rightPoints: [Geometry.Point<2>] = []

        leftPoints.reserveCapacity(controlPoints.count)
        rightPoints.reserveCapacity(controlPoints.count)

        var points = controlPoints
        leftPoints.append(points.first!)
        rightPoints.insert(points.last!, at: 0)

        while points.count > 1 {
            var next: [Geometry.Point<2>] = []
            next.reserveCapacity(points.count - 1)
            for i in 0..<(points.count - 1) {
                let p = points[i].lerp(to: points[i + 1], t: t)
                next.append(p)
            }
            leftPoints.append(next.first!)
            rightPoints.insert(next.last!, at: 0)
            points = next
        }

        return (Self(controlPoints: leftPoints), Self(controlPoints: rightPoints))
    }

    /// Subdivide the curve into multiple segments for approximation.
    ///
    /// - Parameter segments: Number of segments to create
    /// - Returns: Array of points along the curve
    @inlinable
    public func subdivide(into segments: Int) -> [Geometry.Point<2>] {
        .init(subdividing: self, into: segments)
    }
}

// MARK: - Array from Bezier Subdivision

extension Array {
    /// Create an array of points by subdividing a Bezier curve.
    ///
    /// - Parameters:
    ///   - bezier: The Bezier curve to subdivide
    ///   - segments: Number of segments to create
    @inlinable
    public init<Scalar: FloatingPoint, Space>(
        subdividing bezier: Geometry<Scalar, Space>.Bezier,
        into segments: Int
    ) where Element == Geometry<Scalar, Space>.Point<2> {
        guard segments > 0 else {
            self = []
            return
        }

        var points: [Geometry<Scalar, Space>.Point<2>] = []
        points.reserveCapacity(segments + 1)

        for i in 0...segments {
            let t: Scale<1, Scalar> = .init(Scalar(i) / Scalar(segments))
            if let p = bezier.point(at: t) {
                points.append(p)
            }
        }

        self = points
    }
}

// MARK: - Bounding Box (FloatingPoint)

extension Geometry.Bezier where Scalar: FloatingPoint {
    /// A conservative bounding box (control point hull).
    ///
    /// This is the axis-aligned bounding box of the control points,
    /// which always contains the curve.
    @inlinable
    public var boundingBoxConservative: Geometry.Rectangle? {
        guard let first = controlPoints.first else { return nil }

        var minX = first.x
        var maxX = first.x
        var minY = first.y
        var maxY = first.y

        for point in controlPoints.dropFirst() {
            minX = .min(minX, point.x)
            maxX = .max(maxX, point.x)
            minY = .min(minY, point.y)
            maxY = .max(maxY, point.y)
        }

        return Geometry.Rectangle(
            llx: minX,
            lly: minY,
            urx: maxX,
            ury: maxY
        )
    }
}

// MARK: - Length Approximation (FloatingPoint)

extension Geometry.Bezier where Scalar: FloatingPoint {
    /// Approximate the arc length of the curve.
    ///
    /// Uses subdivision to approximate the length by summing chord lengths.
    ///
    /// - Parameter segments: Number of segments for approximation (default 100)
    /// - Returns: Approximate arc length
    @inlinable
    public func length(segments: Int = 100) -> Geometry.ArcLength {
        let points = subdivide(into: segments)
        guard points.count >= 2 else { return .zero }

        var len: Geometry.Length = .zero
        for i in 0..<(points.count - 1) {
            len += points[i].distance(to: points[i + 1])
        }
        return len
    }
}

// MARK: - Transformation (FloatingPoint)

extension Geometry.Bezier where Scalar: FloatingPoint {
    /// Return a curve translated by the given vector.
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        Self(controlPoints: controlPoints.map { $0 + vector })
    }

    /// Return a curve scaled uniformly about its start point.
    @inlinable
    public func scaled(by factor: Scale<1, Scalar>) -> Self? {
        guard let start = startPoint else { return nil }
        return scaled(by: factor, about: start)
    }

    /// Return a curve scaled uniformly about a given point.
    @inlinable
    public func scaled(by factor: Scale<1, Scalar>, about point: Geometry.Point<2>) -> Self {
        Self(
            controlPoints: controlPoints.map { p in
                Geometry.Point(
                    x: point.x + factor * (p.x - point.x),
                    y: point.y + factor * (p.y - point.y)
                )
            }
        )
    }

    /// Return the curve with reversed direction.
    @inlinable
    public var reversed: Self {
        Self(controlPoints: controlPoints.reversed())
    }
}

// MARK: - Ellipse Approximation (Real & BinaryFloatingPoint)

extension Geometry.Bezier where Scalar: Real & BinaryFloatingPoint {
    /// Create cubic Bezier curves that approximate an ellipse.
    ///
    /// Uses the standard technique of splitting the ellipse into 4 quadrants,
    /// each approximated by a cubic Bezier curve.
    ///
    /// - Parameter ellipse: The ellipse to approximate
    /// - Returns: Array of 4 cubic Bezier curves approximating the ellipse
    @inlinable
    public static func approximating(_ ellipse: Geometry.Ellipse) -> [Self] {
        // Control point factor for 90° arc approximation
        // k = (4/3) * tan(π/8) ≈ 0.5522847498
        let k: Scalar = Scalar(0.5522847498307936)

        let cx: Scalar = ellipse.center.x._rawValue
        let cy: Scalar = ellipse.center.y._rawValue
        let a: Scalar = ellipse.semiMajor._rawValue
        let b: Scalar = ellipse.semiMinor._rawValue
        let cosR: Scalar = ellipse.rotation.cos.value
        let sinR: Scalar = ellipse.rotation.sin.value

        // Helper to rotate a point around the center
        func rotated(x: Scalar, y: Scalar) -> Geometry.Point<2> {
            let rx: Scalar = x * cosR - y * sinR
            let ry: Scalar = x * sinR + y * cosR
            return Geometry.Point(
                x: Geometry.X(cx + rx),
                y: Geometry.Y(cy + ry)
            )
        }

        // Cardinal points on the unrotated ellipse (relative to center)
        let right = rotated(x: a, y: Scalar(0))
        let top = rotated(x: Scalar(0), y: b)
        let left = rotated(x: -a, y: Scalar(0))
        let bottom = rotated(x: Scalar(0), y: -b)

        // Control point offsets
        let ka: Scalar = k * a
        let kb: Scalar = k * b

        // Control points for each quadrant
        // Quadrant 1: right to top
        let c1_1 = rotated(x: a, y: kb)
        let c1_2 = rotated(x: ka, y: b)

        // Quadrant 2: top to left
        let c2_1 = rotated(x: -ka, y: b)
        let c2_2 = rotated(x: -a, y: kb)

        // Quadrant 3: left to bottom
        let c3_1 = rotated(x: -a, y: -kb)
        let c3_2 = rotated(x: -ka, y: -b)

        // Quadrant 4: bottom to right
        let c4_1 = rotated(x: ka, y: -b)
        let c4_2 = rotated(x: a, y: -kb)

        return [
            .cubic(from: right, control1: c1_1, control2: c1_2, to: top),
            .cubic(from: top, control1: c2_1, control2: c2_2, to: left),
            .cubic(from: left, control1: c3_1, control2: c3_2, to: bottom),
            .cubic(from: bottom, control1: c4_1, control2: c4_2, to: right),
        ]
    }

    /// Create cubic Bezier curves that approximate a circle.
    ///
    /// - Parameter circle: The circle to approximate
    /// - Returns: Array of 4 cubic Bezier curves approximating the circle
    @inlinable
    public static func approximating(_ circle: Geometry.Circle) -> [Self] {
        approximating(Geometry.Ellipse(circle))
    }
}

// MARK: - Bezier Static Implementations

extension Geometry where Scalar: FloatingPoint {
    /// Evaluate a Bezier curve at parameter t using de Casteljau's algorithm.
    @inlinable
    public static func point(of bezier: Bezier, at t: Scale<1, Scalar>) -> Point<2>? {
        guard bezier.isValid else { return nil }

        // de Casteljau's algorithm
        var points = bezier.controlPoints
        while points.count > 1 {
            var next: [Point<2>] = []
            next.reserveCapacity(points.count - 1)
            for i in 0..<(points.count - 1) {
                let p = points[i].lerp(to: points[i + 1], t: t)
                next.append(p)
            }
            points = next
        }
        return points.first
    }

    /// Evaluate the derivative (tangent vector) of a Bezier curve at parameter t.
    @inlinable
    public static func derivative(of bezier: Bezier, at t: Scale<1, Scalar>) -> Vector<2>? {
        guard bezier.controlPoints.count >= 2 else { return nil }

        // Derivative of Bezier curve is n * Bezier(P[i+1] - P[i])
        let n = Scalar(bezier.controlPoints.count - 1)

        // Create derivative control points
        var derivPoints: [Point<2>] = []
        derivPoints.reserveCapacity(bezier.controlPoints.count - 1)
        for i in 0..<(bezier.controlPoints.count - 1) {
            let dx = bezier.controlPoints[i + 1].x._rawValue - bezier.controlPoints[i].x._rawValue
            let dy = bezier.controlPoints[i + 1].y._rawValue - bezier.controlPoints[i].y._rawValue
            derivPoints.append(Point(x: X(dx), y: Y(dy)))
        }

        // Evaluate the derivative curve
        var points = derivPoints
        while points.count > 1 {
            var next: [Point<2>] = []
            next.reserveCapacity(points.count - 1)
            for i in 0..<(points.count - 1) {
                let p = points[i].lerp(to: points[i + 1], t: t)
                next.append(p)
            }
            points = next
        }

        guard let p = points.first else { return nil }
        return Vector(
            dx: Linear<Scalar, Space>.Dx(n * p.x._rawValue),
            dy: Linear<Scalar, Space>.Dy(n * p.y._rawValue)
        )
    }
}

// MARK: - Functorial Map

extension Geometry.Bezier {
    /// Create a curve by transforming the coordinates of another curve
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Geometry<U, Space>.Bezier,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        var result: [Geometry.Point<2>] = []
        result.reserveCapacity(other.controlPoints.count)
        for point in other.controlPoints {
            result.append(try Geometry.Point<2>(point, transform))
        }
        self.init(controlPoints: result)
    }

    /// Transform coordinates using the given closure
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Geometry<Result, Space>.Bezier {
        var result: [Geometry<Result, Space>.Point<2>] = []
        result.reserveCapacity(controlPoints.count)
        for point in controlPoints {
            result.append(try point.map(transform))
        }
        return Geometry<Result, Space>.Bezier(controlPoints: result)
    }
}
