// Radian+Trigonometry.swift
// Trigonometric functions and constants for Radian.

public import RealModule

// MARK: - Trigonometric Functions

extension Radian {
    /// Sine of the angle.
    @inlinable
    public var sin: Double { Double.sin(value) }

    /// Cosine of the angle.
    @inlinable
    public var cos: Double { Double.cos(value) }

    /// Tangent of the angle.
    @inlinable
    public var tan: Double { Double.tan(value) }
}

// MARK: - Inverse Trigonometric Functions

extension Radian {
    /// Creates an angle from its sine value.
    ///
    /// - Parameter value: Sine value in range [-1, 1]
    /// - Returns: Angle in range [-π/2, π/2]
    @inlinable
    public static func asin(_ value: Double) -> Self {
        Self(Double.asin(value))
    }

    /// Creates an angle from its cosine value.
    ///
    /// - Parameter value: Cosine value in range [-1, 1]
    /// - Returns: Angle in range [0, π]
    @inlinable
    public static func acos(_ value: Double) -> Self {
        Self(Double.acos(value))
    }

    /// Creates an angle from its tangent value.
    ///
    /// - Parameter value: Tangent value
    /// - Returns: Angle in range [-π/2, π/2]
    @inlinable
    public static func atan(_ value: Double) -> Self {
        Self(Double.atan(value))
    }

    /// Creates an angle from y and x coordinates using atan2.
    ///
    /// - Parameter y: Y coordinate
    /// - Parameter x: X coordinate
    /// - Returns: Angle in range [-π, π]
    @inlinable
    public static func atan2(y: Double, x: Double) -> Self {
        Self(Double.atan2(y: y, x: x))
    }
}

// MARK: - Constants

extension Radian {
    /// Pi radians (180°)
    @inlinable
    public static var pi: Self { Self(Double.pi) }

    /// Two pi radians (360°, full circle)
    @inlinable
    public static var twoPi: Self { Self(2 * Double.pi) }

    /// Half pi radians (90°, right angle)
    @inlinable
    public static var halfPi: Self { Self(Double.pi / 2) }

    /// Quarter pi radians (45°)
    @inlinable
    public static var quarterPi: Self { Self(Double.pi / 4) }

    /// Returns π divided by the given value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let angle = Radian.pi(over: 3)  // π/3 = 60°
    /// ```
    @inlinable
    public static func pi(over n: Double) -> Self {
        Self(Double.pi / n)
    }

    /// Returns π multiplied by the given value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let angle = Radian.pi(times: 1.5)  // 3π/2 = 270°
    /// ```
    @inlinable
    public static func pi(times n: Double) -> Self {
        Self(Double.pi * n)
    }
}

// MARK: - Normalization

extension Radian {
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
        var result = value.truncatingRemainder(dividingBy: 2 * Double.pi)
        if result < 0 {
            result += 2 * Double.pi
        }
        return Self(result)
    }
}

// MARK: - Conversion

extension Radian {
    /// Creates a radian angle from degrees.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let deg = Degree(90)
    /// let rad = Radian(degrees: deg)  // Radian(π/2)
    /// ```
    @inlinable
    public init(degrees: Degree) {
        self.value = degrees.value * Double.pi / 180
    }

    /// Converts to degrees.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rad = Radian(.pi)
    /// print(rad.degrees)  // Degree(180.0)
    /// ```
    @inlinable
    public var degrees: Degree {
        Degree(radians: self)
    }
}
