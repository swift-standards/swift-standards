// Radian.swift
// An angle measured in radians, implemented as a Tagged type.

public import RealModule

/// An angle measured in radians (dimensionless ratio of arc length to radius).
///
/// Radians are the natural unit for angular measurement, representing pure ratios
/// independent of coordinate systems. Use radians for mathematical operations,
/// trigonometry, and when working with the standard library's `Double` math functions.
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
public typealias Radian<Scalar> = Angle.Radian.Value<Scalar>

// MARK: - Common Angles

extension Tagged where Tag == Angle.Radian, RawValue: BinaryFloatingPoint {
    /// Zero radians
    @inlinable
    public static var zero: Self { Self(0) }

    /// π/2 radians (90°)
    @inlinable
    public static var halfPi: Self { Self(.pi / 2) }

    /// 2π radians (360°)
    @inlinable
    public static var twoPi: Self { Self(.pi * 2) }

    /// π/4 radians (45°)
    @inlinable
    public static var quarterPi: Self { Self(.pi / 4) }
}

// MARK: - Conversion

extension Tagged where Tag == Angle.Radian, RawValue: BinaryFloatingPoint {
    /// Creates a radian angle from degrees.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let deg = Degree(90)
    /// let rad = Radian(degrees: deg)  // Radian(π/2)
    /// ```
    @inlinable
    public init(degrees: Degree<RawValue>) {
        self.init(degrees._rawValue * .pi / 180)
    }
}

extension Tagged where Tag == Angle.Radian, RawValue: BinaryFloatingPoint {
    /// Converts to degrees.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rad = Radian(.pi)
    /// print(rad.degrees)  // Degree(180)
    /// ```
    @inlinable
    public var degrees: Degree<RawValue> {
        Degree(radians: self)
    }
}
