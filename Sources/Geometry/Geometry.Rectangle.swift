// Rectangle.swift
// A rectangle defined by corner coordinates, parameterized by unit type.

extension Geometry {
    /// A rectangle parameterized by its unit type.
    ///
    /// Rectangles are defined by their lower-left (ll) and upper-right (ur) corners,
    /// following the convention used in PDF and many graphics systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bounds: Geometry.Rectangle<Double> = .init(x: 0, y: 0, width: 612, height: 792)
    /// ```
    public struct Rectangle {
        /// Lower-left x coordinate
        public let llx: Unit

        /// Lower-left y coordinate
        public let lly: Unit

        /// Upper-right x coordinate
        public let urx: Unit

        /// Upper-right y coordinate
        public let ury: Unit

        /// Create a rectangle from corner coordinates
        ///
        /// - Parameters:
        ///   - llx: Lower-left x coordinate
        ///   - lly: Lower-left y coordinate
        ///   - urx: Upper-right x coordinate
        ///   - ury: Upper-right y coordinate
        public init(llx: consuming Unit, lly: consuming Unit, urx: consuming Unit, ury: consuming Unit) {
            self.llx = llx
            self.lly = lly
            self.urx = urx
            self.ury = ury
        }
    }
}

extension Geometry.Rectangle: Sendable where Unit: Sendable {}
extension Geometry.Rectangle: Equatable where Unit: Equatable {}
extension Geometry.Rectangle: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Rectangle: Codable where Unit: Codable {}

// MARK: - AdditiveArithmetic Convenience

extension Geometry.Rectangle where Unit: AdditiveArithmetic {
    /// Create a rectangle from origin and size
    ///
    /// - Parameters:
    ///   - x: Lower-left x coordinate
    ///   - y: Lower-left y coordinate
    ///   - width: Width of the rectangle
    ///   - height: Height of the rectangle
    public init(x: Unit, y: Unit, width: Unit, height: Unit) {
        self.llx = x
        self.lly = y
        self.urx = x + width
        self.ury = y + height
    }

    /// Width of the rectangle
    public var width: Unit {
        urx - llx
    }

    /// Height of the rectangle
    public var height: Unit {
        ury - lly
    }

    /// Size of the rectangle
    public var size: Geometry.Size<2> {
        Geometry.Size(width: width, height: height)
    }

    /// Origin (lower-left corner) of the rectangle
    public var origin: Geometry.Point<2> {
        Geometry.Point(x: llx, y: lly)
    }

    /// Create a rectangle from origin point and size
    ///
    /// - Parameters:
    ///   - origin: Lower-left corner point
    ///   - size: Width and height of the rectangle
    public init(origin: Geometry.Point<2>, size: Geometry.Size<2>) {
        self.llx = origin.x
        self.lly = origin.y
        self.urx = origin.x + size.width
        self.ury = origin.y + size.height
    }
}

// MARK: - Corner Access

extension Geometry.Rectangle {
    /// Lower edge corners
    public enum LowerEdge {
        case left, right
    }

    /// Upper edge corners
    public enum UpperEdge {
        case left, right
    }

    /// All four corners
    public enum Corner {
        case lowerLeft, lowerRight, upperLeft, upperRight
    }

    /// Get a corner coordinate
    ///
    /// - Parameter corner: The corner to retrieve
    /// - Returns: The corner as a Point
    public func corner(_ corner: Corner) -> Geometry.Point<2> {
        switch corner {
        case .lowerLeft:
            return Geometry.Point(x: llx, y: lly)
        case .lowerRight:
            return Geometry.Point(x: urx, y: lly)
        case .upperLeft:
            return Geometry.Point(x: llx, y: ury)
        case .upperRight:
            return Geometry.Point(x: urx, y: ury)
        }
    }
}

// MARK: - Functional Updates

extension Geometry.Rectangle {
    /// Create a new rectangle with a modified lower-left x
    public func with(llx: Unit) -> Self {
        Self(llx: llx, lly: lly, urx: urx, ury: ury)
    }

    /// Create a new rectangle with a modified lower-left y
    public func with(lly: Unit) -> Self {
        Self(llx: llx, lly: lly, urx: urx, ury: ury)
    }

    /// Create a new rectangle with a modified upper-right x
    public func with(urx: Unit) -> Self {
        Self(llx: llx, lly: lly, urx: urx, ury: ury)
    }

    /// Create a new rectangle with a modified upper-right y
    public func with(ury: Unit) -> Self {
        Self(llx: llx, lly: lly, urx: urx, ury: ury)
    }
}

// MARK: - Comparable-based Rectangle Operations

extension Geometry.Rectangle where Unit: Comparable {
    /// Minimum x (same as llx for normalized rectangles)
    @inlinable
    public var minX: Unit { min(llx, urx) }

    /// Maximum x (same as urx for normalized rectangles)
    @inlinable
    public var maxX: Unit { max(llx, urx) }

    /// Minimum y (same as lly for normalized rectangles)
    @inlinable
    public var minY: Unit { min(lly, ury) }

    /// Maximum y (same as ury for normalized rectangles)
    @inlinable
    public var maxY: Unit { max(lly, ury) }

    /// Check if the rectangle contains a point
    @inlinable
    public func contains(_ point: Geometry.Point<2>) -> Bool {
        point.x >= minX && point.x <= maxX &&
        point.y >= minY && point.y <= maxY
    }

    /// Check if this rectangle contains another rectangle
    @inlinable
    public func contains(_ other: Self) -> Bool {
        other.minX >= minX && other.maxX <= maxX &&
        other.minY >= minY && other.maxY <= maxY
    }

    /// Check if this rectangle intersects another
    @inlinable
    public func intersects(_ other: Self) -> Bool {
        minX <= other.maxX && maxX >= other.minX &&
        minY <= other.maxY && maxY >= other.minY
    }

    /// The union of this rectangle with another
    @inlinable
    public func union(_ other: Self) -> Self {
        Self(
            llx: min(minX, other.minX),
            lly: min(minY, other.minY),
            urx: max(maxX, other.maxX),
            ury: max(maxY, other.maxY)
        )
    }

    /// The intersection of this rectangle with another, if they intersect
    @inlinable
    public func intersection(_ other: Self) -> Self? {
        guard intersects(other) else { return nil }
        return Self(
            llx: max(minX, other.minX),
            lly: max(minY, other.minY),
            urx: min(maxX, other.maxX),
            ury: min(maxY, other.maxY)
        )
    }
}

// MARK: - FloatingPoint-based Rectangle Operations

extension Geometry.Rectangle where Unit: FloatingPoint {
    /// Center x coordinate
    @inlinable
    public var midX: Unit { (llx + urx) / 2 }

    /// Center y coordinate
    @inlinable
    public var midY: Unit { (lly + ury) / 2 }

    /// Center point
    @inlinable
    public var center: Geometry.Point<2> {
        Geometry.Point(x: midX, y: midY)
    }

    /// Return a rectangle inset by the given amounts
    @inlinable
    public func insetBy(dx: Unit, dy: Unit) -> Self {
        Self(llx: llx + dx, lly: lly + dy, urx: urx - dx, ury: ury - dy)
    }

    /// Return a rectangle inset by edge insets
    @inlinable
    public func inset(by insets: Geometry.EdgeInsets) -> Self {
        Self(
            llx: llx + insets.leading,
            lly: lly + insets.bottom,
            urx: urx - insets.trailing,
            ury: ury - insets.top
        )
    }
}

// MARK: - Functorial Map

extension Geometry.Rectangle {
    /// Create a rectangle by transforming each coordinate of another rectangle
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Rectangle, _ transform: (U) -> Unit) {
        self.init(
            llx: transform(other.llx),
            lly: transform(other.lly),
            urx: transform(other.urx),
            ury: transform(other.ury)
        )
    }

    /// Transform each coordinate using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Rectangle {
        Geometry<Result>.Rectangle(
            llx: try transform(llx),
            lly: try transform(lly),
            urx: try transform(urx),
            ury: try transform(ury)
        )
    }
}

// MARK: - Bifunctor

extension Geometry.Rectangle where Unit: AdditiveArithmetic {
    /// Create a rectangle by independently transforming origin and size
    @inlinable
    public init<U>(
        _ other: Geometry<U>.Rectangle,
        transformOrigin: (Geometry<U>.Point<2>) -> Geometry.Point<2>,
        transformSize: (Geometry<U>.Size<2>) -> Geometry.Size<2>
    ) where U: AdditiveArithmetic {
        let newOrigin = transformOrigin(other.origin)
        let newSize = transformSize(other.size)
        self.init(origin: newOrigin, size: newSize)
    }
}
