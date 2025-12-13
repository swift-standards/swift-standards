// Linear.Vector+Real.swift
// Angle and rotation operations for 2D vectors with Real scalar types.

public import Angle
public import Dimension
public import RealModule

// MARK: - Angle from Vector

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// The angle of this vector from the positive X-axis.
    @inlinable
    public static func angle(_ vector: Self) -> Radian<Scalar> {
        .atan2(y: vector.dy, x: vector.dx)
    }

    /// The angle of this vector from the positive X-axis.
    @inlinable
    public var angle: Radian<Scalar> {
        Self.angle(self)
    }
}

// MARK: - Vector from Angle

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Creates a unit vector at the given angle from the positive X-axis.
    @inlinable
    public static func unit(at angle: Radian<Scalar>) -> Self {
        Self(dx: Linear.Dx(angle.cos.value), dy: Linear.Dy(angle.sin.value))
    }

    /// Creates a vector from polar coordinates (length and angle).
    @inlinable
    public static func polar(length: Linear.Length, angle: Radian<Scalar>) -> Self {
        Self(
            dx: Linear.Dx(length._rawValue * angle.cos.value),
            dy: Linear.Dy(length._rawValue * angle.sin.value)
        )
    }
}

// MARK: - Angle Between Vectors

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Computes the unsigned angle between this vector and another.
    ///
    /// Returns an angle in the range [0, π].
    @inlinable
    public static func angle(_ lhs: Self, to rhs: Self) -> Radian<Scalar> {
        let dotProduct = dot(lhs, rhs)
        let magnitudes = length(lhs) * length(rhs)
        guard magnitudes > 0 else { return .zero }
        return .acos(Scale(dotProduct / magnitudes))
    }

    /// Computes the unsigned angle between this vector and another.
    ///
    /// Returns an angle in the range [0, π].
    @inlinable
    public func angle(to other: Self) -> Radian<Scalar> {
        Self.angle(self, to: other)
    }

    /// Computes the signed angle from this vector to another.
    ///
    /// Returns an angle in (-π, π], positive for counter-clockwise rotation.
    /// Note: cross returns Area, dot returns Scalar (both dimension Length²), ratio is dimensionless.
    @inlinable
    public static func signedAngle(_ lhs: Self, to rhs: Self) -> Radian<Scalar> {
        let crossProduct = cross(lhs, rhs)._rawValue
        let dotProduct = dot(lhs, rhs)
        return Radian(Scalar.atan2(y: crossProduct, x: dotProduct))
    }

    /// Computes the signed angle from this vector to another.
    ///
    /// Returns an angle in (-π, π], positive for counter-clockwise rotation.
    @inlinable
    public func signedAngle(to other: Self) -> Radian<Scalar> {
        Self.signedAngle(self, to: other)
    }
}

// MARK: - Rotation

extension Linear.Vector where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Rotates this vector by an angle in radians.
    @inlinable
    public static func rotated(_ vector: Self, by angle: Radian<Scalar>) -> Self {
        let c = angle.cos.value
        let s = angle.sin.value
        let x = vector.dx._rawValue
        let y = vector.dy._rawValue
        return Self(
            dx: Linear.Dx(x * c - y * s),
            dy: Linear.Dy(x * s + y * c)
        )
    }

    /// Rotates this vector by an angle in radians.
    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    /// Rotates this vector by an angle in degrees.
    @inlinable
    public static func rotated(_ vector: Self, by angle: Degree<Scalar>) -> Self {
        rotated(vector, by: angle.radians)
    }

    /// Rotates this vector by an angle in degrees.
    @inlinable
    public func rotated(by angle: Degree<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }
}
