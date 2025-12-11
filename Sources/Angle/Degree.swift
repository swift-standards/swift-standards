// Degree.swift
// An angle measured in degrees (dimensionless).

/// An angle measured in degrees (1/360 of a full rotation).
///
/// Degrees provide an intuitive unit for angles familiar to most users, with 360° representing a complete circle. Use degrees for user-facing values, UI controls, and when working with geographic coordinates or navigation.
///
/// ## Example
///
/// ```swift
/// let rightAngle = Degree(90)
/// print(rightAngle.radians)         // Radian(π/2)
/// print(rightAngle.sin)             // 1.0
///
/// // Arithmetic operations
/// let rotation = rightAngle * 2     // Degree(180)
/// let half = rightAngle / 2         // Degree(45)
/// ```
public struct Degree: Sendable, Hashable, Codable {
    /// Angle value (degrees)
    public var value: Double

    /// Creates an angle from a degree value.
    @inlinable
    public init(_ value: Double) {
        self.value = value
    }
}

// MARK: - AdditiveArithmetic

extension Degree: AdditiveArithmetic {
    @inlinable
    public static var zero: Self { Self(0) }

    @inlinable
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value + rhs.value)
    }

    @inlinable
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value - rhs.value)
    }
}

// MARK: - Comparable

extension Degree: Comparable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Numeric

extension Degree: Numeric {
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
    public static func * (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value * rhs.value)
    }

    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs.value *= rhs.value
    }
}

// MARK: - SignedNumeric

extension Degree: SignedNumeric {
    /// Negates the angle (reverses direction).
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Division

extension Degree {
    /// Divides the angle by a scalar value.
    @inlinable
    @_disfavoredOverload
    public static func / (lhs: borrowing Self, rhs: Double) -> Self {
        Self(lhs.value / rhs)
    }

    /// Divides one angle by another, returning their scalar ratio.
    @inlinable
    @_disfavoredOverload
    public static func / (lhs: borrowing Self, rhs: borrowing Self) -> Double {
        lhs.value / rhs.value
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Degree: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Double) {
        self.value = value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Degree: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        self.value = Double(value)
    }
}

// MARK: - Common Angles

extension Degree {
    /// Right angle (90°)
    public static let rightAngle = Self(90)

    /// Straight angle (180°)
    public static let straight = Self(180)

    /// Full circle (360°)
    public static let fullCircle = Self(360)

    /// Forty-five degrees (45°)
    public static let fortyFive = Self(45)

    /// Sixty degrees (60°)
    public static let sixty = Self(60)

    /// Thirty degrees (30°)
    public static let thirty = Self(30)
}

// MARK: - Conversion

extension Degree {
    /// Creates a degree angle from radians.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rad = Radian(.pi / 2)
    /// let deg = Degree(radians: rad)  // Degree(90.0)
    /// ```
    @inlinable
    public init(radians: Radian) {
        self.value = radians.value * 180 / Double.pi
    }

    /// Converts to radians.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let deg = Degree(180)
    /// print(deg.radians)  // Radian(π)
    /// ```
    @inlinable
    public var radians: Radian {
        Radian(degrees: self)
    }
}

// MARK: - Trigonometry (via Radian)

extension Degree {
    /// Sine of the angle.
    @inlinable
    public var sin: Double { radians.sin }

    /// Cosine of the angle.
    @inlinable
    public var cos: Double { radians.cos }

    /// Tangent of the angle.
    @inlinable
    public var tan: Double { radians.tan }
}
