// Path.swift
// A 2D path composed of line segments, Bezier curves, and arcs.

public import Affine
public import RealModule

// MARK: - Path

extension Geometry {
    /// A path consisting of one or more subpaths.
    ///
    /// Path is a general-purpose vector path representation that composes
    /// existing geometric primitives. Use this for representing complex
    /// shapes, outlines, and composite curves.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Triangle path
    /// let triangle = Geometry<Double, Void>.Path(subpaths: [
    ///     .init(
    ///         startPoint: .init(x: 0, y: 0),
    ///         segments: [
    ///             .line(.init(start: .init(x: 0, y: 0), end: .init(x: 100, y: 0))),
    ///             .line(.init(start: .init(x: 100, y: 0), end: .init(x: 50, y: 86.6))),
    ///         ],
    ///         isClosed: true  // Automatically closes back to start
    ///     )
    /// ])
    /// ```
    public struct Path {
        /// The subpaths that make up this path
        public var subpaths: [Subpath]

        /// Create a path from subpaths
        @inlinable
        public init(subpaths: consuming [Subpath]) {
            self.subpaths = subpaths
        }
    }
}

extension Geometry.Path: Sendable where Scalar: Sendable {}
extension Geometry.Path: Equatable where Scalar: Equatable {}
extension Geometry.Path: Hashable where Scalar: Hashable {}

#if Codable
extension Geometry.Path: Codable where Scalar: Codable {}
#endif

// MARK: - Path.Subpath

extension Geometry.Path {
    /// A connected sequence of segments forming a subpath.
    ///
    /// A subpath starts at a point and consists of connected segments.
    /// If `isClosed` is true, a line from the last segment's endpoint
    /// to `startPoint` is implied.
    public struct Subpath {
        /// The starting point of the subpath
        public var startPoint: Geometry.Point<2>

        /// The segments making up the subpath
        public var segments: [Segment]

        /// Whether the subpath is closed (end connects to start)
        public var isClosed: Bool

        /// Create a subpath
        @inlinable
        public init(
            startPoint: consuming Geometry.Point<2>,
            segments: consuming [Segment],
            isClosed: Bool = false
        ) {
            self.startPoint = startPoint
            self.segments = segments
            self.isClosed = isClosed
        }
    }
}

extension Geometry.Path.Subpath: Sendable where Scalar: Sendable {}
extension Geometry.Path.Subpath: Equatable where Scalar: Equatable {}
extension Geometry.Path.Subpath: Hashable where Scalar: Hashable {}

#if Codable
extension Geometry.Path.Subpath: Codable where Scalar: Codable {}
#endif

// MARK: - Path.Segment

extension Geometry.Path {
    /// A single segment of a path.
    ///
    /// Represents a primitive geometric element that can be part of a path.
    public enum Segment {
        /// A straight line segment
        case line(Geometry.Line.Segment)

        /// A Bezier curve (any degree)
        case bezier(Geometry.Bezier)

        /// A circular arc
        case arc(Geometry.Arc)
    }
}

extension Geometry.Path.Segment: Sendable where Scalar: Sendable {}
extension Geometry.Path.Segment: Equatable where Scalar: Equatable {}
extension Geometry.Path.Segment: Hashable where Scalar: Hashable {}

#if Codable
extension Geometry.Path.Segment: Codable where Scalar: Codable {}
#endif

// MARK: - Segment Properties

extension Geometry.Path.Segment where Scalar: Real & BinaryFloatingPoint {
    /// The starting point of the segment
    @inlinable
    public var startPoint: Geometry.Point<2>? {
        switch self {
        case .line(let seg): return seg.start
        case .bezier(let bez): return bez.startPoint
        case .arc(let arc): return arc.startPoint
        }
    }

    /// The ending point of the segment
    @inlinable
    public var endPoint: Geometry.Point<2>? {
        switch self {
        case .line(let seg): return seg.end
        case .bezier(let bez): return bez.endPoint
        case .arc(let arc): return arc.endPoint
        }
    }
}

extension Geometry.Path.Segment where Scalar: Real & BinaryFloatingPoint {
    /// Convert segment to Bezier curves
    @inlinable
    public func toBeziers() -> [Geometry.Bezier] {
        switch self {
        case .line(let seg):
            return [.linear(from: seg.start, to: seg.end)]
        case .bezier(let bez):
            return [bez]
        case .arc(let arc):
            return [Geometry.Bezier](arc: arc)
        }
    }
}

// MARK: - Path Properties

extension Geometry.Path {
    /// Whether the path is empty (no subpaths)
    @inlinable
    public var isEmpty: Bool { subpaths.isEmpty }

    /// Total number of segments across all subpaths
    @inlinable
    public var segmentCount: Int {
        subpaths.reduce(0) { $0 + $1.segments.count }
    }
}

extension Geometry.Path where Scalar: Real & BinaryFloatingPoint {
    /// Convert entire path to Bezier curves.
    ///
    /// Useful for rendering or geometric operations that work on Beziers.
    @inlinable
    public func toBeziers() -> [[Geometry.Bezier]] {
        subpaths.map { subpath in
            var beziers = subpath.segments.flatMap { $0.toBeziers() }
            if subpath.isClosed, let last = beziers.last?.endPoint {
                if last != subpath.startPoint {
                    beziers.append(.linear(from: last, to: subpath.startPoint))
                }
            }
            return beziers
        }
    }

    /// Bounding box of the entire path
    @inlinable
    public var boundingBox: Geometry.Rectangle? {
        // Collect all Bezier curves and compute union of bounding boxes
        let allBeziers = toBeziers().flatMap { $0 }
        guard let first = allBeziers.first?.boundingBoxConservative else { return nil }
        return allBeziers.dropFirst().reduce(first) { rect, bez in
            guard let bezRect = bez.boundingBoxConservative else { return rect }
            return rect.union(bezRect)
        }
    }
}

// MARK: - Subpath Properties

extension Geometry.Path.Subpath {
    /// Whether the subpath is empty (no segments)
    @inlinable
    public var isEmpty: Bool { segments.isEmpty }
}

extension Geometry.Path.Subpath where Scalar: Real & BinaryFloatingPoint {
    /// The endpoint of the subpath (last segment's end, or startPoint if empty)
    @inlinable
    public var endPoint: Geometry.Point<2>? {
        segments.last?.endPoint ?? startPoint
    }
}

extension Geometry.Path.Subpath where Scalar: Real & BinaryFloatingPoint {
    /// Approximate length of the subpath
    @inlinable
    public func length(bezierSegments: Int = 100) -> Geometry.ArcLength {
        var total: Geometry.ArcLength = .zero
        for segment in segments {
            switch segment {
            case .line(let seg):
                total += seg.length
            case .bezier(let bez):
                total += bez.length(segments: bezierSegments)
            case .arc(let arc):
                total += arc.length
            }
        }
        if isClosed, let end = endPoint, end != startPoint {
            total += end.distance(to: startPoint)
        }
        return total
    }
}

// MARK: - Path Convenience Initializers

extension Geometry.Path {
    /// Create a path from a single closed polygon
    @inlinable
    public static func polygon(vertices: [Geometry.Point<2>]) -> Self? {
        guard vertices.count >= 3 else { return nil }
        var segments: [Segment] = []
        for i in 0..<(vertices.count - 1) {
            segments.append(.line(.init(start: vertices[i], end: vertices[i + 1])))
        }
        return Self(subpaths: [
            .init(startPoint: vertices[0], segments: segments, isClosed: true)
        ])
    }

    /// Create a path from a polyline (open)
    @inlinable
    public static func polyline(vertices: [Geometry.Point<2>]) -> Self? {
        guard vertices.count >= 2 else { return nil }
        var segments: [Segment] = []
        for i in 0..<(vertices.count - 1) {
            segments.append(.line(.init(start: vertices[i], end: vertices[i + 1])))
        }
        return Self(subpaths: [
            .init(startPoint: vertices[0], segments: segments, isClosed: false)
        ])
    }
}

// MARK: - Functorial Map (Segment)

extension Geometry.Path.Segment {
    /// Transform coordinates using the given closure
    @inlinable
    public func map<Result>(
        _ transform: (Scalar) throws -> Result
    ) rethrows -> Geometry<Result, Space>.Path.Segment {
        switch self {
        case .line(let seg):
            return .line(try seg.map(transform))
        case .bezier(let bez):
            return .bezier(try bez.map(transform))
        case .arc(let arc):
            return .arc(try arc.map(transform))
        }
    }
}

// MARK: - Functorial Map (Subpath)

extension Geometry.Path.Subpath {
    /// Transform coordinates using the given closure
    @inlinable
    public func map<Result>(
        _ transform: (Scalar) throws -> Result
    ) rethrows -> Geometry<Result, Space>.Path.Subpath {
        .init(
            startPoint: try startPoint.map(transform),
            segments: try segments.map { try $0.map(transform) },
            isClosed: isClosed
        )
    }
}

// MARK: - Functorial Map (Path)

extension Geometry.Path {
    /// Transform coordinates using the given closure
    @inlinable
    public func map<Result>(
        _ transform: (Scalar) throws -> Result
    ) rethrows -> Geometry<Result, Space>.Path {
        .init(subpaths: try subpaths.map { try $0.map(transform) })
    }
}
