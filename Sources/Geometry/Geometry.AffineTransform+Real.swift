// AffineTransform+Trigonometry.swift
// Rotation extensions using angles.

public import RealModule

extension Geometry<Double>.AffineTransform {
    /// Create a rotation transform from an angle in radians
    @inlinable
    public static func rotation(_ angle: Geometry<Double>.Radian) -> Self {
        rotation(cos: angle.cos, sin: angle.sin)
    }

    /// Create a rotation transform from an angle in degrees
    @inlinable
    public static func rotation(_ angle: Geometry<Double>.Degree) -> Self {
        rotation(angle.radians)
    }

    /// Return a new transform with rotation applied
    @inlinable
    public func rotated(by angle: Geometry<Double>.Radian) -> Self {
        rotated(cos: angle.cos, sin: angle.sin)
    }

    /// Return a new transform with rotation applied
    @inlinable
    public func rotated(by angle: Geometry<Double>.Degree) -> Self {
        rotated(by: angle.radians)
    }
}
