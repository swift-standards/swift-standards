// Binary.Count.swift
// Non-negative byte count with typed throws.

public import Dimension

extension Binary {
    /// A non-negative byte count in a binary space.
    ///
    /// Construction enforces non-negativity via typed throws.
    ///
    /// ## API Pattern
    ///
    /// - **Primary**: `init(_:) throws(Binary.Error)` — validates at runtime
    /// - **Performance**: `init(unchecked:)` — debug assertion only
    /// - **Literals**: `ExpressibleByIntegerLiteral` — precondition (compile-time known)
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Throwing construction
    /// let count = try Binary.Count(value)
    ///
    /// // Performance path (known valid)
    /// let count = Binary.Count(unchecked: knownPositive)
    ///
    /// // Literals (compile-time checked)
    /// let count: Binary.Count<Int, Space> = 100
    ///
    /// // Error handling
    /// do {
    ///     let count = try Binary.Count(-1)
    /// } catch .negative(let e) {
    ///     print("\(e.field) was \(e.value)")
    /// }
    /// ```
    public struct Count<Scalar: BinaryInteger & Sendable, Space>: Sendable, Equatable, Hashable {
        /// The underlying non-negative value.
        public let _rawValue: Scalar
    }
}

// MARK: - Throwing Initializer

extension Binary.Count {
    /// Creates a count from a raw value.
    ///
    /// - Parameter value: The count value. Must be non-negative.
    /// - Throws: `Binary.Error.negative` if value < 0.
    @inlinable
    public init(_ value: Scalar) throws(Binary.Error) {
        guard value >= 0 else {
            throw .negative(.init(field: .count, value: value))
        }
        self._rawValue = value
    }

    /// Creates a count from a typed extent.
    ///
    /// - Parameter extent: The extent value. Must be non-negative.
    /// - Throws: `Binary.Error.negative` if value < 0.
    @inlinable
    public init(_ extent: Extent.X<Space>.Value<Scalar>) throws(Binary.Error) {
        guard extent._rawValue >= 0 else {
            throw .negative(.init(field: .count, value: extent._rawValue))
        }
        self._rawValue = extent._rawValue
    }
}

// MARK: - Unchecked Initializer

extension Binary.Count {
    /// Creates a count without validation.
    ///
    /// Use this in performance-critical paths where non-negativity
    /// is guaranteed by construction or prior validation.
    ///
    /// - Parameter value: The count value. Must be non-negative.
    /// - Precondition: `value >= 0` (debug-only assertion)
    @inlinable
    public init(unchecked value: Scalar) {
        assert(value >= 0, "Count cannot be negative")
        self._rawValue = value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Binary.Count: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    /// Creates a count from an integer literal.
    ///
    /// Traps if the literal is negative (compile-time known).
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        let scalar = Scalar(integerLiteral: value)
        precondition(scalar >= 0, "Count literal cannot be negative")
        self._rawValue = scalar
    }
}

// MARK: - Comparable

extension Binary.Count: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs._rawValue < rhs._rawValue
    }
}

// MARK: - Zero

extension Binary.Count {
    /// The zero count.
    @inlinable
    public static var zero: Self {
        Self(unchecked: 0)
    }
}

// MARK: - Arithmetic (Non-Throwing)

extension Binary.Count {
    /// Adds two counts.
    ///
    /// Result is guaranteed non-negative since both operands are.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(unchecked: lhs._rawValue + rhs._rawValue)
    }
}

// MARK: - Arithmetic (Throwing)

extension Binary.Count {
    /// Subtracts one count from another.
    ///
    /// - Throws: `Binary.Error.negative` if result would be negative.
    @inlinable
    public static func - (lhs: Self, rhs: Self) throws(Binary.Error) -> Self {
        // Check BEFORE subtraction to avoid unsigned underflow trap
        guard lhs._rawValue >= rhs._rawValue else {
            // Compute what the negative result would be for error reporting
            // Use Int64 to avoid overflow in the error value
            let negativeResult = Int64(clamping: lhs._rawValue) - Int64(clamping: rhs._rawValue)
            throw .negative(.init(field: .count, value: negativeResult))
        }
        return Self(unchecked: lhs._rawValue - rhs._rawValue)
    }
}

// MARK: - CustomStringConvertible

extension Binary.Count: CustomStringConvertible {
    public var description: String {
        "\(_rawValue)"
    }
}

// MARK: - Convenience Alias

//extension Binary {
//    /// Count in this space.
//    public typealias Count<Scalar: FixedWidthInteger & Sendable> = Binary.Count<Scalar, Binary.Space>
//}

