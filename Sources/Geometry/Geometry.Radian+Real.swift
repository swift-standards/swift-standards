// Radian+Trigonometry.swift
// Trigonometric extensions for Radian using swift-numerics Real protocol.

public import RealModule

// MARK: - Trigonometric Functions

extension Geometry.Radian where Unit: Real {
    /// Sine of the angle
    @inlinable
    public var sin: Unit { Unit.sin(value) }

    /// Cosine of the angle
    @inlinable
    public var cos: Unit { Unit.cos(value) }

    /// Tangent of the angle
    @inlinable
    public var tan: Unit { Unit.tan(value) }
}

// MARK: - Inverse Trigonometric Functions (Factory Methods)

extension Geometry.Radian where Unit: Real {
    /// Create a radian angle from its sine value
    @inlinable
    public static func asin(_ value: Unit) -> Self {
        Self(Unit.asin(value))
    }

    /// Create a radian angle from its cosine value
    @inlinable
    public static func acos(_ value: Unit) -> Self {
        Self(Unit.acos(value))
    }

    /// Create a radian angle from its tangent value
    @inlinable
    public static func atan(_ value: Unit) -> Self {
        Self(Unit.atan(value))
    }

    /// Create a radian angle from y/x coordinates (atan2)
    @inlinable
    public static func atan2(y: Unit, x: Unit) -> Self {
        Self(Unit.atan2(y: y, x: x))
    }
}

// MARK: - Constants

extension Geometry.Radian where Unit: Real {
    /// π radians (180°)
    @inlinable
    public static var pi: Self { Self(Unit.pi) }

    /// π multiplied by the given factor
    ///
    /// - Parameter factor: The value to multiply π by
    /// - Returns: π×factor radians
    ///
    /// ## Example
    ///
    /// ```swift
    /// let fullCircle: Geometry<Double>.Radian = .pi(times: 2)  // 2π
    /// ```
    @inlinable
    public static func pi(times factor: Unit) -> Self {
        Self(Unit.pi * factor)
    }

    /// π divided by the given divisor
    ///
    /// - Parameter divisor: The value to divide π by
    /// - Returns: π/divisor radians
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rightAngle: Geometry<Double>.Radian = .pi(over: 2)  // π/2
    /// let halfRight: Geometry<Double>.Radian = .pi(over: 4)   // π/4
    /// ```
    @inlinable
    public static func pi(over divisor: Unit) -> Self {
        Self(Unit.pi / divisor)
    }
}

extension Geometry.Radian where Unit: Real {
    /// Create a radian angle from a degree angle
    @inlinable
    public init(degrees: Geometry<Unit>.Degree) {
        self.init(degrees.value * Unit.pi / 180)
    }

    /// Convert radians to degrees
    @inlinable
    public var degrees: Geometry<Unit>.Degree {
        .init(radians: self)
    }
}
