// Vector+Trigonometry.swift
// Angle and rotation operations for 2D vectors.

public import RealModule

// MARK: - Angle from Vector

extension Geometry<Double>.Vector where N == 2 {
    /// The angle of this vector from the positive x-axis
    @inlinable
    public var angle: Geometry<Double>.Radian {
        .atan2(y: dy, x: dx)
    }
}

extension Geometry<Float>.Vector where N == 2 {
    /// The angle of this vector from the positive x-axis
    @inlinable
    public var angle: Geometry<Float>.Radian {
        .atan2(y: dy, x: dx)
    }
}

// MARK: - Unit Vector at Angle

extension Geometry<Double>.Vector where N == 2 {
    /// Create a unit vector at the given angle
    @inlinable
    public static func unit(at angle: Geometry<Double>.Radian) -> Self {
        Self(dx: angle.cos, dy: angle.sin)
    }

    /// Create a vector with given length at the given angle (polar coordinates)
    @inlinable
    public static func polar(length: Double, angle: Geometry<Double>.Radian) -> Self {
        Self(dx: length * angle.cos, dy: length * angle.sin)
    }
}

extension Geometry<Float>.Vector where N == 2 {
    /// Create a unit vector at the given angle
    @inlinable
    public static func unit(at angle: Geometry<Float>.Radian) -> Self {
        Self(dx: angle.cos, dy: angle.sin)
    }

    /// Create a vector with given length at the given angle (polar coordinates)
    @inlinable
    public static func polar(length: Float, angle: Geometry<Float>.Radian) -> Self {
        Self(dx: length * angle.cos, dy: length * angle.sin)
    }
}

// MARK: - Angle Between Vectors

extension Geometry<Double>.Vector where N == 2 {
    /// The angle between this vector and another
    @inlinable
    public func angle(to other: Self) -> Geometry<Double>.Radian {
        let dotProduct = self.dot(other)
        let magnitudes = self.length * other.length
        guard magnitudes > 0 else { return .zero }
        return .acos(dotProduct / magnitudes)
    }
}

extension Geometry<Float>.Vector where N == 2 {
    /// The angle between this vector and another
    @inlinable
    public func angle(to other: Self) -> Geometry<Float>.Radian {
        let dotProduct = self.dot(other)
        let magnitudes = self.length * other.length
        guard magnitudes > 0 else { return .zero }
        return .acos(dotProduct / magnitudes)
    }
}

// MARK: - Rotation

extension Geometry<Double>.Vector where N == 2 {
    /// Rotate this vector by an angle
    @inlinable
    public func rotated(by angle: Geometry<Double>.Radian) -> Self {
        let c = angle.cos
        let s = angle.sin
        return Self(dx: dx * c - dy * s, dy: dx * s + dy * c)
    }

    /// Rotate this vector by an angle in degrees
    @inlinable
    public func rotated(by angle: Geometry<Double>.Degree) -> Self {
        rotated(by: angle.radians)
    }
}

extension Geometry<Float>.Vector where N == 2 {
    /// Rotate this vector by an angle
    @inlinable
    public func rotated(by angle: Geometry<Float>.Radian) -> Self {
        let c = angle.cos
        let s = angle.sin
        return Self(dx: dx * c - dy * s, dy: dx * s + dy * c)
    }

    /// Rotate this vector by an angle in degrees
    @inlinable
    public func rotated(by angle: Geometry<Float>.Degree) -> Self {
        rotated(by: angle.radians)
    }
}
