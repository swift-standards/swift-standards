// Rectangle.swift
// A rectangle defined by corner coordinates, parameterized by unit type and coordinate space.

public import Affine
public import Algebra_Linear
public import Dimension

extension Geometry {
    /// A rectangle parameterized by its unit type and coordinate space.
    ///
    /// Rectangles are defined by their lower-left (ll) and upper-right (ur) corners,
    /// following the convention used in PDF and many graphics systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bounds: Geometry<Double, Void>.Rectangle = .init(
    ///     x: .init(0), y: .init(0),
    ///     width: .init(612), height: .init(792)
    /// )
    /// ```
    public struct Rectangle {
        /// Lower-left x coordinate
        public var llx: Geometry.X

        /// Lower-left y coordinate
        public var lly: Geometry.Y

        /// Upper-right x coordinate
        public var urx: Geometry.X

        /// Upper-right y coordinate
        public var ury: Geometry.Y

        /// Create a rectangle from corner coordinates
        ///
        /// - Parameters:
        ///   - llx: Lower-left x coordinate
        ///   - lly: Lower-left y coordinate
        ///   - urx: Upper-right x coordinate
        ///   - ury: Upper-right y coordinate
        @inlinable
        public init(
            llx: consuming Geometry.X,
            lly: consuming Geometry.Y,
            urx: consuming Geometry.X,
            ury: consuming Geometry.Y
        ) {
            self.llx = llx
            self.lly = lly
            self.urx = urx
            self.ury = ury
        }
    }
}

extension Geometry.Rectangle: Sendable where Scalar: Sendable {}
extension Geometry.Rectangle: Equatable where Scalar: Equatable {}
extension Geometry.Rectangle: Hashable where Scalar: Hashable {}

// MARK: - Codable
#if Codable
    extension Geometry.Rectangle: Codable where Scalar: Codable {}
#endif

// MARK: - Origin/Size Initializers

extension Geometry.Rectangle where Scalar: AdditiveArithmetic {
    /// Create a rectangle from origin and size
    ///
    /// - Parameters:
    ///   - x: Lower-left x coordinate
    ///   - y: Lower-left y coordinate
    ///   - width: Width of the rectangle
    ///   - height: Height of the rectangle
    @inlinable
    public init(
        x: Geometry.X,
        y: Geometry.Y,
        width: Geometry.Width,
        height: Geometry.Height
    ) {
        self.llx = x
        self.lly = y
        self.urx = x + width
        self.ury = y + height
    }

    /// Width of the rectangle
    @inlinable
    public var width: Geometry.Width {
        get { urx - llx }
        set { urx = llx + newValue }
    }

    /// Height of the rectangle
    @inlinable
    public var height: Geometry.Height {
        get { ury - lly }
        set { ury = lly + newValue }
    }
}

// MARK: - Corner Access

extension Geometry.Rectangle {
    /// Get a corner coordinate
    ///
    /// - Parameter corner: The corner to retrieve
    /// - Returns: The corner as a Point
    @inlinable
    public func corner(_ corner: Region.Corner) -> Geometry.Point<2> {
        switch corner {
        case .bottomLeft:
            return Geometry.Point(x: llx, y: lly)
        case .bottomRight:
            return Geometry.Point(x: urx, y: lly)
        case .topLeft:
            return Geometry.Point(x: llx, y: ury)
        case .topRight:
            return Geometry.Point(x: urx, y: ury)
        default:
            fatalError("Invalid corner")
        }
    }
}

// MARK: - Functional Updates

extension Geometry.Rectangle {
    /// Create a new rectangle with a modified lower-left x
    @inlinable
    public func with(llx: Geometry.X) -> Self {
        Self(llx: llx, lly: lly, urx: urx, ury: ury)
    }

    /// Create a new rectangle with a modified lower-left y
    @inlinable
    public func with(lly: Geometry.Y) -> Self {
        Self(llx: llx, lly: lly, urx: urx, ury: ury)
    }

    /// Create a new rectangle with a modified upper-right x
    @inlinable
    public func with(urx: Geometry.X) -> Self {
        Self(llx: llx, lly: lly, urx: urx, ury: ury)
    }

    /// Create a new rectangle with a modified upper-right y
    @inlinable
    public func with(ury: Geometry.Y) -> Self {
        Self(llx: llx, lly: lly, urx: urx, ury: ury)
    }
}

// MARK: - Translation

extension Geometry.Rectangle where Scalar: AdditiveArithmetic {
    /// Translate the rectangle by the given displacements.
    ///
    /// - Parameters:
    ///   - dx: Horizontal displacement
    ///   - dy: Vertical displacement
    /// - Returns: A new rectangle with translated origin
    @inlinable
    public func translated(
        dx: Geometry.Width,
        dy: Geometry.Height
    ) -> Self {
        Self(
            llx: llx + dx,
            lly: lly + dy,
            urx: urx + dx,
            ury: ury + dy
        )
    }
}

// MARK: - Comparable-based Rectangle Operations

extension Geometry.Rectangle where Scalar: Comparable {
    /// Minimum x (same as llx for normalized rectangles)
    @inlinable
    public var minX: Geometry.X { min(llx, urx) }

    /// Maximum x (same as urx for normalized rectangles)
    @inlinable
    public var maxX: Geometry.X { max(llx, urx) }

    /// Minimum y (same as lly for normalized rectangles)
    @inlinable
    public var minY: Geometry.Y { min(lly, ury) }

    /// Maximum y (same as ury for normalized rectangles)
    @inlinable
    public var maxY: Geometry.Y { max(lly, ury) }
}

extension Geometry.Rectangle where Scalar: SignedNumeric & Comparable {
    /// Check if the rectangle has zero or negative area.
    ///
    /// A rectangle is empty if either its width or height is less than or equal to zero.
    @inlinable
    public var isEmpty: Bool {
        urx.value - llx.value <= .zero || ury.value - lly.value <= .zero
    }
}

extension Geometry.Rectangle where Scalar: Comparable {
    /// Check if the rectangle contains a point
    @inlinable
    public func contains(_ point: Geometry.Point<2>) -> Bool {
        point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
    }

    /// Check if this rectangle contains another rectangle
    @inlinable
    public func contains(_ other: Self) -> Bool {
        other.minX >= minX && other.maxX <= maxX && other.minY >= minY && other.maxY <= maxY
    }

    /// Check if this rectangle intersects another
    @inlinable
    public func intersects(_ other: Self) -> Bool {
        minX <= other.maxX && maxX >= other.minX && minY <= other.maxY && maxY >= other.minY
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

extension Geometry.Rectangle where Scalar: FloatingPoint {
    /// Center x coordinate
    @inlinable
    public var midX: Geometry.X { .init((llx.value + urx.value) / 2) }

    /// Center y coordinate
    @inlinable
    public var midY: Geometry.Y { .init((lly.value + ury.value) / 2) }

    /// Center point of the rectangle
    @inlinable
    public var center: Geometry.Point<2> {
        Geometry.Point(x: midX, y: midY)
    }

    /// Return a rectangle inset by the given amounts
    @inlinable
    public func insetBy(
        dx: Geometry.Width,
        dy: Geometry.Height
    ) -> Self {
        Self(llx: llx + dx, lly: lly + dy, urx: urx - dx, ury: ury - dy)
    }
}

// MARK: - Dimension Clamping

extension Geometry.Rectangle where Scalar: Comparable & AdditiveArithmetic {
    /// Returns a rectangle with width clamped to at most the given maximum.
    ///
    /// The rectangle's origin and height are preserved. If the current width
    /// is already ≤ maxWidth, returns self unchanged.
    ///
    /// - Parameter maxWidth: The upper bound for width
    /// - Returns: A rectangle with `width ≤ maxWidth`
    @inlinable
    public func clamped(maxWidth: Geometry.Width) -> Self {
        guard width.value > maxWidth.value else { return self }
        var copy = self
        copy.width = maxWidth
        return copy
    }

    /// Returns a rectangle with height clamped to at most the given maximum.
    ///
    /// The rectangle's origin and width are preserved. If the current height
    /// is already ≤ maxHeight, returns self unchanged.
    ///
    /// - Parameter maxHeight: The upper bound for height
    /// - Returns: A rectangle with `height ≤ maxHeight`
    @inlinable
    public func clamped(maxHeight: Geometry.Height) -> Self {
        guard height.value > maxHeight.value else { return self }
        var copy = self
        copy.height = maxHeight
        return copy
    }
}

// MARK: - Functorial Map

extension Geometry.Rectangle {
    /// Create a rectangle by transforming each coordinate of another rectangle
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Geometry<U, Space>.Rectangle,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        self.init(
            llx: .init(try transform(other.llx.value)),
            lly: .init(try transform(other.lly.value)),
            urx: .init(try transform(other.urx.value)),
            ury: .init(try transform(other.ury.value))
        )
    }

    /// Transform each coordinate using the given closure
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Geometry<Result, Space>.Rectangle {
        Geometry<Result, Space>.Rectangle(
            llx: .init(try transform(llx.value)),
            lly: .init(try transform(lly.value)),
            urx: .init(try transform(urx.value)),
            ury: .init(try transform(ury.value))
        )
    }
}
