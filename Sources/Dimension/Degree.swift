// Degree.swift
// An angle measured in degrees, implemented as a Tagged type.

public import RealModule
/// An angle measured in degrees (1/360 of a full rotation).
///
/// Degrees provide an intuitive unit for angles familiar to most users,
/// with 360° representing a complete circle. Use degrees for user-facing values,
/// UI controls, and when working with geographic coordinates or navigation.
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
public typealias Degree<Scalar> = Angle.Degree.Value<Scalar>

// MARK: - Common Angles

extension Tagged where Tag == Angle.Degree, RawValue: Real {
    /// Zero degrees
    @inlinable
    public static var zero: Self { Self(0) }

    /// Right angle (90°)
    @inlinable
    public static var rightAngle: Self { Self(90) }

    /// Straight angle (180°)
    @inlinable
    public static var straight: Self { Self(180) }

    /// Full circle (360°)
    @inlinable
    public static var fullCircle: Self { Self(360) }

    /// Forty-five degrees (45°)
    @inlinable
    public static var fortyFive: Self { Self(45) }

    /// Sixty degrees (60°)
    @inlinable
    public static var sixty: Self { Self(60) }

    /// Thirty degrees (30°)
    @inlinable
    public static var thirty: Self { Self(30) }
}

// MARK: - Conversion

extension Tagged where Tag == Angle.Degree, RawValue: BinaryFloatingPoint {
    /// Creates a degree angle from radians.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rad = Radian(.pi / 2)
    /// let deg = Degree(radians: rad)  // Degree(90.0)
    /// ```
    @inlinable
    public init(radians: Radian<RawValue>) {
        self.init(radians._rawValue * 180 / .pi)
    }
}

extension Tagged where Tag == Angle.Degree, RawValue: BinaryFloatingPoint {
    /// Converts to radians.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let deg = Degree(180)
    /// print(deg.radians)  // Radian(π)
    /// ```
    @inlinable
    public var radians: Radian<RawValue> {
        Radian(degrees: self)
    }
}

// MARK: - Trigonometry (via Radians)

extension Tagged where Tag == Angle.Degree, RawValue: Real & BinaryFloatingPoint {
    /// Sine of the angle.
    @inlinable
    public var sin: Scale<1, RawValue> { radians.sin }

    /// Cosine of the angle.
    @inlinable
    public var cos: Scale<1, RawValue> { radians.cos }

    /// Tangent of the angle.
    @inlinable
    public var tan: Scale<1, RawValue> { radians.tan }
}
