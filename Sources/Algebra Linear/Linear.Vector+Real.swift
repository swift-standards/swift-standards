// Linear.Vector+Real.swift
// Angle and rotation operations for 2D vectors with Real scalar types.

public import Algebra
public import Angle
public import Dimension
public import RealModule

// MARK: - Angle from Vector

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// The angle of this vector from the positive X-axis.
    @inlinable
    public static func angle(_ vector: Self) -> Radian {
        .atan2(y: Double(vector.dy.value), x: Double(vector.dx.value))
    }

    /// The angle of this vector from the positive X-axis.
    @inlinable
    public var angle: Radian {
        Self.angle(self)
    }
}

// MARK: - Scalar Vector at Angle

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Creates a unit vector at the given angle from the positive X-axis.
    @inlinable
    public static func unit(at angle: Radian) -> Self {
        Self(dx: Linear.Dx(Scalar(angle.cos)), dy: Linear.Dy(Scalar(angle.sin)))
    }

    /// Creates a vector from polar coordinates (length and angle).
    @inlinable
    public static func polar(length: Scalar, angle: Radian) -> Self {
        Self(
            dx: Linear.Dx(length * Scalar(angle.cos)),
            dy: Linear.Dy(length * Scalar(angle.sin))
        )
    }
}

// MARK: - Angle Between Vectors

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Computes the unsigned angle between this vector and another.
    ///
    /// Returns an angle in the range [0, π].
    @inlinable
    public static func angle(_ lhs: Self, to rhs: Self) -> Radian {
        let dotProduct = dot(lhs, rhs)
        let magnitudes = length(lhs) * length(rhs)
        guard magnitudes > 0 else { return .zero }
        return .acos(Double(dotProduct / magnitudes))
    }

    /// Computes the unsigned angle between this vector and another.
    ///
    /// Returns an angle in the range [0, π].
    @inlinable
    public func angle(to other: Self) -> Radian {
        Self.angle(self, to: other)
    }

    /// Computes the signed angle from this vector to another.
    ///
    /// Returns an angle in (-π, π], positive for counter-clockwise rotation.
    @inlinable
    public static func signedAngle(_ lhs: Self, to rhs: Self) -> Radian {
        let cross = cross(lhs, rhs)
        let dot = dot(lhs, rhs)
        return .atan2(y: Double(cross), x: Double(dot))
    }

    /// Computes the signed angle from this vector to another.
    ///
    /// Returns an angle in (-π, π], positive for counter-clockwise rotation.
    @inlinable
    public func signedAngle(to other: Self) -> Radian {
        Self.signedAngle(self, to: other)
    }
}

// MARK: - Rotation

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Rotates this vector by an angle in radians.
    @inlinable
    public static func rotated(_ vector: Self, by angle: Radian) -> Self {
        let c = Scalar(angle.cos)
        let s = Scalar(angle.sin)
        let x = vector.dx.value
        let y = vector.dy.value
        return Self(
            dx: Linear.Dx(x * c - y * s),
            dy: Linear.Dy(x * s + y * c)
        )
    }

    /// Rotates this vector by an angle in radians.
    @inlinable
    public func rotated(by angle: Radian) -> Self {
        Self.rotated(self, by: angle)
    }

    /// Rotates this vector by an angle in degrees.
    @inlinable
    public static func rotated(_ vector: Self, by angle: Degree) -> Self {
        rotated(vector, by: angle.radians)
    }

    /// Rotates this vector by an angle in degrees.
    @inlinable
    public func rotated(by angle: Degree) -> Self {
        Self.rotated(self, by: angle)
    }
}
