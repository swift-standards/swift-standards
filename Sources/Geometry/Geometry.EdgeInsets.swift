// EdgeInsets.swift
// Insets from the edges of a rectangle.

extension Geometry {
    /// Insets from the edges of a rectangle, parameterized by unit type.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let margins: Geometry.EdgeInsets<Double> = .init(
    ///     top: 72, leading: 72, bottom: 72, trailing: 72
    /// )
    /// ```
    public struct EdgeInsets {
        /// Top inset
        public var top: Unit

        /// Leading (left in LTR) inset
        public var leading: Unit

        /// Bottom inset
        public var bottom: Unit

        /// Trailing (right in LTR) inset
        public var trailing: Unit

        /// Create edge insets
        ///
        /// - Parameters:
        ///   - top: Top inset
        ///   - leading: Leading inset
        ///   - bottom: Bottom inset
        ///   - trailing: Trailing inset
        public init(top: consuming Unit, leading: consuming Unit, bottom: consuming Unit, trailing: consuming Unit) {
            self.top = top
            self.leading = leading
            self.bottom = bottom
            self.trailing = trailing
        }
    }
}

extension Geometry.EdgeInsets: Sendable where Unit: Sendable {}
extension Geometry.EdgeInsets: Equatable where Unit: Equatable {}
extension Geometry.EdgeInsets: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.EdgeInsets: Codable where Unit: Codable {}

// MARK: - Convenience Initializers

extension Geometry.EdgeInsets {
    /// Create edge insets with the same value on all edges
    ///
    /// - Parameter all: The inset value for all edges
    public init(all: Unit) {
        self.top = all
        self.leading = all
        self.bottom = all
        self.trailing = all
    }

    /// Create edge insets with horizontal and vertical values
    ///
    /// - Parameters:
    ///   - horizontal: Inset for leading and trailing edges
    ///   - vertical: Inset for top and bottom edges
    public init(horizontal: Unit, vertical: Unit) {
        self.top = vertical
        self.leading = horizontal
        self.bottom = vertical
        self.trailing = horizontal
    }
}

// MARK: - Zero

extension Geometry.EdgeInsets where Unit: AdditiveArithmetic {
    /// Zero insets
    public static var zero: Self {
        Self(top: .zero, leading: .zero, bottom: .zero, trailing: .zero)
    }
}

// MARK: - Functorial Map

extension Geometry.EdgeInsets {
    /// Create edge insets by transforming each value of another edge insets
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.EdgeInsets, _ transform: (U) -> Unit) {
        self.init(
            top: transform(other.top),
            leading: transform(other.leading),
            bottom: transform(other.bottom),
            trailing: transform(other.trailing)
        )
    }

    /// Transform each inset value using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.EdgeInsets {
        Geometry<Result>.EdgeInsets(
            top: try transform(top),
            leading: try transform(leading),
            bottom: try transform(bottom),
            trailing: try transform(trailing)
        )
    }
}

// MARK: - Monoid

extension Geometry.EdgeInsets where Unit: AdditiveArithmetic {
    /// Combine two edge insets by adding their values
    @inlinable
    public static func combined(_ lhs: borrowing Self, _ rhs: borrowing Self) -> Self {
        Self(
            top: lhs.top + rhs.top,
            leading: lhs.leading + rhs.leading,
            bottom: lhs.bottom + rhs.bottom,
            trailing: lhs.trailing + rhs.trailing
        )
    }
}
