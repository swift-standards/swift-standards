// Radian.swift
// An angle measured in radians (dimensionless).

/// An angle measured in radians (dimensionless ratio of arc length to radius).
///
/// Radians are the natural unit for angular measurement, representing pure ratios independent of coordinate systems. Use radians for mathematical operations, trigonometry, and when working with the standard library's `Double` math functions.
///
/// ## Example
///
/// ```swift
/// let angle = Radian(.pi / 4)       // 45°
/// print(angle.sin)                  // 0.7071...
/// print(angle.degrees)              // Degree(45.0)
///
/// // Arithmetic operations
/// let doubled = angle * 2           // Radian(π/2) = 90°
/// let sum = angle + Radian(.pi)     // Radian(5π/4) = 225°
/// ```
public struct Radian: Sendable, Hashable, Codable {
    /// Angle value (radians)
    public var value: Double

    /// Creates an angle from a radian value.
    @inlinable
    public init(_ value: Double) {
        self.value = value
    }
}

// MARK: - AdditiveArithmetic

extension Radian: AdditiveArithmetic {
    @inlinable
    public static var zero: Self { Self(0) }

    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value + rhs.value)
    }

    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value - rhs.value)
    }
}

// MARK: - Comparable

extension Radian: Comparable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Numeric

extension Radian: Numeric {
    public typealias Magnitude = Self

    @inlinable
    public var magnitude: Self {
        Self(value.magnitude)
    }

    @inlinable
    public init?<T: BinaryInteger>(exactly source: T) {
        guard let value = Double(exactly: source) else { return nil }
        self.value = value
    }

    /// Multiplies two angles (scalar scaling).
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value * rhs.value)
    }

    @inlinable
    @_disfavoredOverload
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs.value *= rhs.value
    }
}

// MARK: - SignedNumeric

extension Radian: SignedNumeric {
    /// Negates the angle (reverses direction).
    @inlinable
    @_disfavoredOverload
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Division

extension Radian {
    /// Divides the angle by a scalar value.
    @inlinable
    @_disfavoredOverload
    public static func / (lhs: borrowing Self, rhs: Double) -> Self {
        Self(lhs.value / rhs)
    }

    //    /// Divide angle by angle (returns scalar ratio)
    //    @inlinable
    //    @_disfavoredOverload
    //    public static func / (lhs: borrowing Self, rhs: borrowing Self) -> Double {
    //        lhs.value / rhs.value
    //    }
}

// MARK: - ExpressibleByFloatLiteral

extension Radian: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Double) {
        self.value = value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Radian: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        self.value = Double(value)
    }
}
