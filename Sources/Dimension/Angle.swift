// Angle.swift
// Namespace for angular measurements.
//
// Angle types represent dimensionless quantities (ratios) that are independent
// of any coordinate system. They form the circle group S¹ = ℝ/2πℤ, supporting
// addition, subtraction, and scalar multiplication while maintaining type safety
// between radians and degrees.

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

// MARK: - Value Typealiases

// Usage: Angle.Radian.Value<Scalar> instead of Tagged<Angle.Radian, Scalar>

extension Angle.Radian {
    /// A tagged radian value.
    public typealias Value<Scalar> = Tagged<Angle.Radian, Scalar>
}

extension Angle.Degree {
    /// A tagged degree value.
    public typealias Value<Scalar> = Tagged<Angle.Degree, Scalar>
}
