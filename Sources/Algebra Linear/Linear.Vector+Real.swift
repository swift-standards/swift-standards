// Linear.Vector+Real.swift
// Angle and rotation operations for 2D vectors with Real scalar types.

public import Angle
public import RealModule

// MARK: - Angle from Vector

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// The angle of this vector from the positive x-axis
    @inlinable
    public var angle: Radian {
        .atan2(y: Double(dy), x: Double(dx))
    }
}

// MARK: - Scalar Vector at Angle

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Create a unit vector at the given angle
    @inlinable
    public static func unit(at angle: Radian) -> Self {
        Self(dx: Scalar(angle.cos), dy: Scalar(angle.sin))
    }

    /// Create a vector with given length at the given angle (polar coordinates)
    @inlinable
    public static func polar(length: Scalar, angle: Radian) -> Self {
        Self(
            dx: length * Scalar(angle.cos),
            dy: length * Scalar(angle.sin)
        )
    }
}

// MARK: - Angle Between Vectors

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// The angle between this vector and another (always positive).
    ///
    /// Returns the unsigned angle in [0, π].
    @inlinable
    public func angle(to other: Self) -> Radian {
        let dotProduct = self.dot(other)
        let magnitudes = self.length * other.length
        guard magnitudes > 0 else { return .zero }
        return .acos(Double(dotProduct / magnitudes))
    }

    /// The signed angle from this vector to another.
    ///
    /// Returns the angle in (-π, π], positive for counter-clockwise rotation.
    @inlinable
    public func signedAngle(to other: Self) -> Radian {
        let cross = self.cross(other)
        let dot = self.dot(other)
        return .atan2(y: Double(cross), x: Double(dot))
    }
}

// MARK: - Rotation

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Rotate this vector by an angle
    @inlinable
    public func rotated(by angle: Radian) -> Self {
        let c = Scalar(angle.cos)
        let s = Scalar(angle.sin)
        let x = dx
        let y = dy
        return Self(
            dx: x * c - y * s,
            dy: x * s + y * c
        )
    }

    /// Rotate this vector by an angle in degrees
    @inlinable
    public func rotated(by angle: Degree) -> Self {
        rotated(by: angle.radians)
    }
}
