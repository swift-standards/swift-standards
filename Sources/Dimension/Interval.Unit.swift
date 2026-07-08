// Interval.Unit.swift
// A value in the closed unit interval [0, 1].

// MARK: - Unit Struct

extension Interval where Scalar: BinaryFloatingPoint {
    /// A value in the closed unit interval [0, 1].
    ///
    /// `Interval.Unit` represents normalized continuous values commonly used for
    /// opacity, alpha, progress, interpolation parameters, and other fractional quantities.
    ///
    /// ## Mathematical Properties
    ///
    /// The unit interval [0, 1] forms a monoid under multiplication:
    /// - Closed: `Unit * Unit = Unit` (product of values in [0,1] stays in [0,1])
    /// - Associative: `(a * b) * c = a * (b * c)`
    /// - Identity: `Unit.one` (1 * x = x)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let opacity: Interval<Double>.Unit = .half
    /// let layerAlpha: Opacity<Double> = Opacity(0.8)!
    ///
    /// // Compose opacities by multiplication
    /// let combined = opacity * layerAlpha  // 0.4
    ///
    /// // Complement for inverse
    /// let transparency = opacity.complement  // 0.5
    ///
    /// // Linear interpolation
    /// let blended = Opacity<Double>.zero.interpolated(to: .one, at: opacity)
    /// ```
    public struct Unit {
        /// The underlying value in [0, 1].
        @usableFromInline internal var _storage: Scalar

        // MARK: - Initializers

        /// Creates a unit value if within bounds and finite.
        ///
        /// - Parameter value: A scalar value
        /// - Returns: The unit value, or `nil` if value is outside [0, 1] or non-finite
        ///
        /// ## Example
        ///
        /// ```swift
        /// let valid = Interval<Double>.Unit(0.5)    // Optional(0.5)
        /// let invalid = Interval<Double>.Unit(1.5)  // nil
        /// let nan = Interval<Double>.Unit(.nan)     // nil
        /// ```
        @inlinable
        public init?(_ value: Scalar) {
            guard value.isFinite && value >= 0 && value <= 1 else { return nil }
            self._storage = value
        }

        /// Creates a unit value without bounds checking.
        ///
        /// - Precondition: `value` must be in [0, 1] and finite (not NaN or infinity)
        /// - Parameter value: A scalar value known to be in bounds
        ///
        /// Use this initializer only when you have already validated the input
        /// or when constructing from known-safe values.
        @inlinable
        public init(
            __unchecked: Void,
            _ value: Scalar
        ) {
            assert(value.isFinite, "Interval.Unit requires finite values")
            assert(value >= 0 && value <= 1, "Interval.Unit requires value in [0, 1]")
            self._storage = value
        }

        /// Creates a unit value by clamping to [0, 1].
        ///
        /// - Parameter value: Any scalar value
        ///
        /// Values below 0 become 0, values above 1 become 1.
        /// NaN and negative infinity become 0, positive infinity becomes 1.
        ///
        /// ## Example
        ///
        /// ```swift
        /// let clamped = Interval<Double>.Unit(clamping: 1.5)   // 1.0
        /// let negative = Interval<Double>.Unit(clamping: -0.5) // 0.0
        /// let nan = Interval<Double>.Unit(clamping: .nan)      // 0.0
        /// ```
        @inlinable
        public init(clamping value: Scalar) {
            if value.isNaN {
                self._storage = 0
            } else {
                self._storage = min(max(value, 0), 1)
            }
        }
    }
}

// MARK: - Raw Value Access

extension Interval.Unit {
    /// The underlying value in [0, 1].
    @inlinable
    public var rawValue: Scalar { _storage }

    /// Deprecated: Use `rawValue` instead.
    @available(
        *,
        deprecated,
        renamed: "rawValue",
        message: "Use 'rawValue' instead. '_rawValue' will be removed in a future version."
    )
    @inlinable
    public var _rawValue: Scalar { _storage }
}

// MARK: - Sendable

extension Interval.Unit: Sendable where Scalar: Sendable {}

// MARK: - Equatable

extension Interval.Unit: Equatable where Scalar: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs._storage == rhs._storage
    }
}

// MARK: - Hashable

extension Interval.Unit: Hashable where Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_storage)
    }
}

// MARK: - Comparable

extension Interval.Unit: Comparable where Scalar: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs._storage < rhs._storage
    }
}

// MARK: - Special Values

extension Interval.Unit {
    /// Zero (minimum value).
    @inlinable
    public static var zero: Self { Self(__unchecked: (), 0) }

    /// One (maximum value).
    @inlinable
    public static var one: Self { Self(__unchecked: (), 1) }

    /// Half (midpoint).
    @inlinable
    public static var half: Self { Self(__unchecked: (), Scalar(0.5)) }
}

// MARK: - Operations

extension Interval.Unit {
    /// The complement: 1 - self.
    ///
    /// For opacity, this gives transparency. For progress, this gives remaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let opacity: Opacity<Double> = .half
    /// let transparency = opacity.complement  // 0.5
    /// ```
    @inlinable
    public var complement: Self {
        // Clamp to handle floating-point edge cases
        Self(__unchecked: (), min(max(1 - _storage, 0), 1))
    }

    /// Linear interpolation from self to another value.
    ///
    /// Computes `self * (1 - t) + other * t`.
    ///
    /// - Parameters:
    ///   - other: The target value
    ///   - t: The interpolation parameter (0 = self, 1 = other)
    /// - Returns: The interpolated value
    ///
    /// ## Example
    ///
    /// ```swift
    /// let start: Opacity<Double> = .zero
    /// let end: Opacity<Double> = .one
    /// let mid = start.interpolated(to: end, at: .half)  // 0.5
    /// ```
    @inlinable
    public func interpolated(to other: Self, at t: Self) -> Self {
        // Clamp to handle floating-point edge cases
        let result = _storage * (1 - t._storage) + other._storage * t._storage
        return Self(__unchecked: (), min(max(result, 0), 1))
    }
}

// MARK: - Multiplication (Monoid)

extension Interval.Unit {
    /// Product of two unit values.
    ///
    /// The unit interval is closed under multiplication: the product of
    /// values in [0, 1] is always in [0, 1].
    ///
    /// ## Example
    ///
    /// ```swift
    /// let layer1: Opacity<Double> = Opacity(0.8)!
    /// let layer2: Opacity<Double> = Opacity(0.5)!
    /// let combined = layer1 * layer2  // 0.4
    /// ```
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        // Clamp to handle floating-point edge cases
        Self(__unchecked: (), min(max(lhs._storage * rhs._storage, 0), 1))
    }

    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Interval.Unit: ExpressibleByFloatLiteral
where Scalar: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Scalar.FloatLiteralType

    /// Creates a unit value from a float literal.
    ///
    /// In debug builds, asserts that the literal is in [0, 1].
    /// In release builds, clamps out-of-bounds values.
    @inlinable
    public init(floatLiteral value: FloatLiteralType) {
        let scalar = Scalar(floatLiteral: value)
        assert(
            scalar.isFinite && scalar >= 0 && scalar <= 1,
            "Float literal must be finite and in [0, 1]"
        )
        // Clamp in release builds for safety
        self._storage = scalar.isNaN ? 0 : min(max(scalar, 0), 1)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Interval.Unit: ExpressibleByIntegerLiteral
where Scalar: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Scalar.IntegerLiteralType

    /// Creates a unit value from an integer literal (0 or 1).
    ///
    /// In debug builds, asserts that the literal is 0 or 1.
    /// In release builds, clamps out-of-bounds values.
    @inlinable
    public init(integerLiteral value: IntegerLiteralType) {
        let scalar = Scalar(integerLiteral: value)
        assert(
            scalar >= 0 && scalar <= 1,
            "Integer literal must be 0 or 1"
        )
        // Clamp in release builds for safety
        self._storage = min(max(scalar, 0), 1)
    }
}

// MARK: - Codable

#if !hasFeature(Embedded)
    extension Interval.Unit: Codable where Scalar: Codable {
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(Scalar.self)
            guard let unit = Self(value) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "Value \(value) out of bounds for Interval.Unit (expected [0, 1])"
                    )
                )
            }
            self = unit
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(_storage)
        }
    }
#endif

// MARK: - Type Aliases

/// A normalized opacity value in [0, 1].
///
/// 0 = fully transparent, 1 = fully opaque.
///
/// ## Example
///
/// ```swift
/// let opaque: Opacity<Double> = .one
/// let halfVisible: Opacity<Double> = .half
/// let faded = opaque * halfVisible  // 0.5
/// ```
public typealias Opacity<Scalar: BinaryFloatingPoint> = Interval<Scalar>.Unit

/// A normalized alpha value in [0, 1].
///
/// Alias for `Opacity`. Use whichever name fits your domain better.
public typealias Alpha<Scalar: BinaryFloatingPoint> = Opacity<Scalar>
