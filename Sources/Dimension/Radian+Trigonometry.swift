// Radian+Trigonometry.swift
// Trigonometric functions and constants for Radian.

public import RealModule

// MARK: - Trigonometric Functions (Static Implementation)

extension Tagged where Tag == Angle.Radian, RawValue: Real {
    /// Sine of an angle.
    ///
    /// Returns a dimensionless scale factor (ratio of opposite/hypotenuse).
    @inlinable
    public static func sin(of angle: Self) -> Scale<1, RawValue> {
        Scale(RawValue.sin(angle._rawValue))
    }

    /// Cosine of an angle.
    ///
    /// Returns a dimensionless scale factor (ratio of adjacent/hypotenuse).
    @inlinable
    public static func cos(of angle: Self) -> Scale<1, RawValue> {
        Scale(RawValue.cos(angle._rawValue))
    }

    /// Tangent of an angle.
    ///
    /// Returns a dimensionless scale factor (ratio of opposite/adjacent).
    @inlinable
    public static func tan(of angle: Self) -> Scale<1, RawValue> {
        Scale(RawValue.tan(angle._rawValue))
    }
}

// MARK: - Trigonometric Functions (Instance Convenience)

extension Tagged where Tag == Angle.Radian, RawValue: Real {
    /// Sine of the angle.
    @inlinable
    public var sin: Scale<1, RawValue> { Self.sin(of: self) }

    /// Cosine of the angle.
    @inlinable
    public var cos: Scale<1, RawValue> { Self.cos(of: self) }

    /// Tangent of the angle.
    @inlinable
    public var tan: Scale<1, RawValue> { Self.tan(of: self) }
}

// MARK: - Inverse Trigonometric Functions

extension Tagged where Tag == Angle.Radian, RawValue: Real {
    /// Creates an angle from its sine value.
    ///
    /// - Parameter ratio: Sine value (dimensionless ratio) in range [-1, 1]
    /// - Returns: Angle in range [-π/2, π/2]
    @inlinable
    public static func asin(_ ratio: Scale<1, RawValue>) -> Self {
        Self(RawValue.asin(ratio.value))
    }

    /// Creates an angle from its cosine value.
    ///
    /// - Parameter ratio: Cosine value (dimensionless ratio) in range [-1, 1]
    /// - Returns: Angle in range [0, π]
    @inlinable
    public static func acos(_ ratio: Scale<1, RawValue>) -> Self {
        Self(RawValue.acos(ratio.value))
    }

    /// Creates an angle from its tangent value.
    ///
    /// - Parameter ratio: Tangent value (dimensionless ratio)
    /// - Returns: Angle in range [-π/2, π/2]
    @inlinable
    public static func atan(_ ratio: Scale<1, RawValue>) -> Self {
        Self(RawValue.atan(ratio.value))
    }

    /// Creates an angle from y and x displacements using atan2.
    ///
    /// - Parameter y: Y displacement component
    /// - Parameter x: X displacement component
    /// - Returns: Angle in range [-π, π]
    @inlinable
    public static func atan2<Space>(
        y: Displacement.Y<Space>.Value<RawValue>,
        x: Displacement.X<Space>.Value<RawValue>
    ) -> Self {
        Self(RawValue.atan2(y: y._rawValue, x: x._rawValue))
    }
}

// MARK: - Pi Helpers

extension Tagged where Tag == Angle.Radian, RawValue: Real {
    /// Returns π divided by the given value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let angle = Radian.pi(over: 3)  // π/3 = 60°
    /// ```
    @inlinable
    public static func pi(over n: RawValue) -> Self {
        Self(RawValue.pi / n)
    }

    /// Returns π multiplied by the given value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let angle = Radian.pi(times: 1.5)  // 3π/2 = 270°
    /// ```
    @inlinable
    public static func pi(times n: RawValue) -> Self {
        Self(RawValue.pi * n)
    }
}

// MARK: - Normalization

extension Tagged where Tag == Angle.Radian, RawValue: Real {
    /// Normalizes an angle to the range [0, 2π).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let angle = Radian(3 * .pi)
    /// print(Radian.normalized(angle))  // Radian(π) ≈ 3.14...
    ///
    /// let negative = Radian(-.pi / 2)
    /// print(Radian.normalized(negative))  // Radian(3π/2) ≈ 4.71...
    /// ```
    @inlinable
    public static func normalized(_ angle: Self) -> Self {
        var result = angle._rawValue.truncatingRemainder(dividingBy: 2 * RawValue.pi)
        if result < 0 {
            result += 2 * RawValue.pi
        }
        return Self(result)
    }

    /// Normalizes the angle to the range [0, 2π).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let angle = Radian(3 * .pi)
    /// print(angle.normalized)  // Radian(π) ≈ 3.14...
    ///
    /// let negative = Radian(-.pi / 2)
    /// print(negative.normalized)  // Radian(3π/2) ≈ 4.71...
    /// ```
    @inlinable
    public var normalized: Self {
        Self.normalized(self)
    }
}
