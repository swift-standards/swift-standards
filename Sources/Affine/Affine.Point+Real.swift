// Affine.Point+Real.swift
// Polar coordinates and rotation for 2D points with Real scalar types.

public import Algebra
import Algebra_Linear
public import Angle
public import RealModule

// MARK: - Polar Coordinates

extension Affine.Point where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Create a point at polar coordinates from the origin
    @inlinable
    public static func polar(radius: Scalar, angle: Radian) -> Self {
        Self(
            x: Affine.X(radius * Scalar(angle.cos)),
            y: Affine.Y(radius * Scalar(angle.sin))
        )
    }

    /// The angle from the origin to this point
    @inlinable
    public var angle: Radian {
        .atan2(y: Double(y.value), x: Double(x.value))
    }

    /// The distance from the origin (radius in polar coordinates)
    @inlinable
    public var radius: Scalar {
        Scalar.sqrt(x.value * x.value + y.value * y.value)
    }
}

// MARK: - Rotation

extension Affine.Point where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Rotate this point around the origin by an angle
    @inlinable
    public func rotated(by angle: Radian) -> Self {
        let c = Scalar(angle.cos)
        let s = Scalar(angle.sin)
        let px = x.value
        let py = y.value
        return Self(
            x: Affine.X(px * c - py * s),
            y: Affine.Y(px * s + py * c)
        )
    }

    /// Rotate this point around a center point by an angle
    @inlinable
    public func rotated(by angle: Radian, around center: Self) -> Self {
        let translated = Self(
            x: Affine.X(x.value - center.x.value),
            y: Affine.Y(y.value - center.y.value)
        )
        let rotated = translated.rotated(by: angle)
        return Self(
            x: Affine.X(rotated.x.value + center.x.value),
            y: Affine.Y(rotated.y.value + center.y.value)
        )
    }

    /// Rotate this point around the origin by an angle in degrees
    @inlinable
    public func rotated(by angle: Degree) -> Self {
        rotated(by: angle.radians)
    }

    /// Rotate this point around a center point by an angle in degrees
    @inlinable
    public func rotated(by angle: Degree, around center: Self) -> Self {
        rotated(by: angle.radians, around: center)
    }
}
