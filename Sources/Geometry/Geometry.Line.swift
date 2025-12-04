// Line.swift
// An infinite line and its bounded segment in 2D space.

extension Geometry {
    /// An infinite line in 2D space.
    ///
    /// A line extends infinitely in both directions and can be defined by:
    /// - A point and a direction vector
    /// - Two distinct points
    ///
    /// For a bounded portion of a line, see `Line.Segment`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Line through origin with direction (1, 1)
    /// let diagonal = Geometry<Double>.Line(
    ///     point: .init(x: 0, y: 0),
    ///     direction: .init(dx: 1, dy: 1)
    /// )
    ///
    /// // Line through two points
    /// let line = Geometry<Double>.Line(
    ///     from: .init(x: 0, y: 0),
    ///     to: .init(x: 10, y: 10)
    /// )
    /// ```
    public struct Line {
        /// A point on the line
        public var point: Point<2>

        /// The direction vector of the line (not necessarily normalized)
        public var direction: Vector<2>

        /// Create a line from a point and direction vector
        @inlinable
        public init(point: consuming Point<2>, direction: consuming Vector<2>) {
            self.point = point
            self.direction = direction
        }
    }
}

extension Geometry.Line: Sendable where Unit: Sendable {}
extension Geometry.Line: Equatable where Unit: Equatable {}
extension Geometry.Line: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Line: Codable where Unit: Codable {}

// MARK: - Factory Methods (AdditiveArithmetic)

extension Geometry.Line where Unit: AdditiveArithmetic {
    /// Create a line through two points
    ///
    /// - Parameters:
    ///   - from: First point on the line
    ///   - to: Second point on the line
    @inlinable
    public init(from: Geometry.Point<2>, to: Geometry.Point<2>) {
        self.point = from
        self.direction = Geometry.Vector(dx: to.x - from.x, dy: to.y - from.y)
    }
}

// MARK: - FloatingPoint Operations

extension Geometry.Line where Unit: FloatingPoint {
    /// A normalized direction vector (unit length)
    @inlinable
    public var normalizedDirection: Geometry.Vector<2> {
        direction.normalized
    }

    /// Get a point on the line at parameter t
    ///
    /// - Parameter t: The parameter (0 = base point, 1 = base point + direction)
    /// - Returns: The point at parameter t
    @inlinable
    public func point(at t: Unit) -> Geometry.Point<2> {
        Geometry.Point(
            x: point.x + t * direction.dx,
            y: point.y + t * direction.dy
        )
    }

    /// The perpendicular distance from a point to this line
    @inlinable
    public func distance(to other: Geometry.Point<2>) -> Unit {
        let v = Geometry.Vector(dx: other.x - point.x, dy: other.y - point.y)
        let cross = direction.dx * v.dy - direction.dy * v.dx
        return abs(cross) / direction.length
    }
}

// MARK: - Line.Segment

extension Geometry.Line {
    /// A bounded segment of a line between two endpoints.
    ///
    /// A segment is the finite portion of a line between two points.
    /// Unlike a line which extends infinitely, a segment has definite
    /// start and end points.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let segment = Geometry<Double>.Line.Segment(
    ///     start: .init(x: 0, y: 0),
    ///     end: .init(x: 100, y: 100)
    /// )
    /// print(segment.length)  // 141.42...
    /// ```
    public struct Segment {
        /// The start point
        public var start: Geometry.Point<2>

        /// The end point
        public var end: Geometry.Point<2>

        /// Create a line segment between two points
        @inlinable
        public init(start: consuming Geometry.Point<2>, end: consuming Geometry.Point<2>) {
            self.start = start
            self.end = end
        }
    }
}

extension Geometry.Line.Segment: Sendable where Unit: Sendable {}
extension Geometry.Line.Segment: Equatable where Unit: Equatable {}
extension Geometry.Line.Segment: Hashable where Unit: Hashable {}

// MARK: - Segment Codable

extension Geometry.Line.Segment: Codable where Unit: Codable {}

// MARK: - Segment Reversed

extension Geometry.Line.Segment {
    /// Return the segment with reversed direction
    @inlinable
    public var reversed: Self {
        Self(start: end, end: start)
    }
}

// MARK: - Segment Vector (AdditiveArithmetic)

extension Geometry.Line.Segment where Unit: AdditiveArithmetic {
    /// The vector from start to end
    @inlinable
    public var vector: Geometry.Vector2 {
        Geometry.Vector2(dx: end.x - start.x, dy: end.y - start.y)
    }

    /// The infinite line containing this segment
    @inlinable
    public var line: Geometry.Line {
        Geometry.Line(point: start, direction: vector)
    }
}

// MARK: - Segment FloatingPoint Operations

extension Geometry.Line.Segment where Unit: FloatingPoint {
    /// The squared length of the segment
    ///
    /// Use this when comparing lengths to avoid the sqrt computation.
    @inlinable
    public var lengthSquared: Unit {
        vector.lengthSquared
    }

    /// The length of the segment
    @inlinable
    public var length: Unit {
        vector.length
    }

    /// The midpoint of the segment
    @inlinable
    public var midpoint: Geometry.Point<2> {
        Geometry.Point(
            x: (start.x + end.x) / 2,
            y: (start.y + end.y) / 2
        )
    }

    /// Get a point along the segment at parameter t
    ///
    /// - Parameter t: Parameter from 0 (start) to 1 (end)
    /// - Returns: The interpolated point
    @inlinable
    public func point(at t: Unit) -> Geometry.Point<2> {
        let x = start.x + t * (end.x - start.x)
        let y = start.y + t * (end.y - start.y)
        return Geometry.Point(x: x, y: y)
    }
}

// MARK: - Backward Compatibility Typealias

extension Geometry {
    /// A line segment between two points.
    ///
    /// This is a typealias for `Line.Segment` for backward compatibility.
    /// Prefer using `Geometry.Line.Segment` for new code.
    public typealias LineSegment = Line.Segment
}

// MARK: - Functorial Map (Line)

extension Geometry.Line {
    /// Create a line by transforming the coordinates of another line
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Line, _ transform: (U) -> Unit) {
        self.init(
            point: Geometry.Point<2>(other.point, transform),
            direction: Geometry.Vector<2>(other.direction, transform)
        )
    }

    /// Transform coordinates using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Line {
        Geometry<Result>.Line(
            point: try point.map(transform),
            direction: try direction.map(transform)
        )
    }
}

// MARK: - Functorial Map (Line.Segment)

extension Geometry.Line.Segment {
    /// Create a segment by transforming the coordinates of another segment
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Line.Segment, _ transform: (U) -> Unit) {
        self.init(
            start: Geometry.Point<2>(other.start, transform),
            end: Geometry.Point<2>(other.end, transform)
        )
    }

    /// Transform coordinates using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Line.Segment {
        Geometry<Result>.Line.Segment(
            start: try start.map(transform),
            end: try end.map(transform)
        )
    }
}
