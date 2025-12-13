// Angle.swift
// Namespace for angular measurements.

/// Namespace for type-safe angular measurements in radians and degrees.
///
/// Angle types represent dimensionless quantities (ratios) that are independent of any coordinate system. They form the circle group S¹ = ℝ/2πℤ, supporting addition, subtraction, and scalar multiplication while maintaining type safety between radians and degrees.
///
/// ## Example
///
/// ```swift
/// let theta = Radian(.pi / 4)  // 45° in radians
/// let phi = Degree(90)         // Right angle in degrees
///
/// // Convert between units
/// let converted = theta.degrees  // Degree(45)
/// let back = phi.radians         // Radian(π/2)
///
/// // Type-safe arithmetic
/// let sum = theta + Radian(.pi / 4)  // Radian(π/2)
/// print(sum.degrees)  // Degree(90.0)
/// ```
///
/// ## Types
///
/// - ``Radian``: Angle measured in radians (arc length / radius)
/// - ``Degree``: Angle measured in degrees (1/360 of a circle)

// MARK: - Angle Namespace

/// Phantom type tags for angular measurements.
///
/// Angles are dimensionless quantities (ratio of arc length to radius for radians,
/// or fraction of a circle for degrees). They don't belong to a coordinate space
/// and aren't part of affine geometry—they're pure scalar measurements.
public enum Angle {
    /// Angle measured in radians (arc length / radius).
    public enum Radian {}

    /// Angle measured in degrees (1/360 of a circle).
    public enum Degree {}
}
