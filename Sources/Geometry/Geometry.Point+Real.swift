// Point+Trigonometry.swift
// Polar coordinates and rotation for 2D points.

public import RealModule

// MARK: - Polar Coordinates (Double)

extension Geometry<Double>.Point where N == 2 {
    /// Create a point at polar coordinates from the origin
    @inlinable
    public static func polar(radius: Double, angle: Geometry<Double>.Radian) -> Self {
        Self(x: radius * angle.cos, y: radius * angle.sin)
    }

    /// The angle from the origin to this point
    @inlinable
    public var angle: Geometry<Double>.Radian {
        .atan2(y: y, x: x)
    }

    /// The distance from the origin (radius in polar coordinates)
    @inlinable
    public var radius: Double {
        Double.sqrt(x * x + y * y)
    }
}

// MARK: - Polar Coordinates (Float)

extension Geometry<Float>.Point where N == 2 {
    /// Create a point at polar coordinates from the origin
    @inlinable
    public static func polar(radius: Float, angle: Geometry<Float>.Radian) -> Self {
        Self(x: radius * angle.cos, y: radius * angle.sin)
    }

    /// The angle from the origin to this point
    @inlinable
    public var angle: Geometry<Float>.Radian {
        .atan2(y: y, x: x)
    }

    /// The distance from the origin (radius in polar coordinates)
    @inlinable
    public var radius: Float {
        Float.sqrt(x * x + y * y)
    }
}

// MARK: - Rotation (Double)

extension Geometry<Double>.Point where N == 2 {
    /// Rotate this point around the origin by an angle
    @inlinable
    public func rotated(by angle: Geometry<Double>.Radian) -> Self {
        let c = angle.cos
        let s = angle.sin
        return Self(x: x * c - y * s, y: x * s + y * c)
    }

    /// Rotate this point around a center point by an angle
    @inlinable
    public func rotated(by angle: Geometry<Double>.Radian, around center: Self) -> Self {
        let translated = Self(x: x - center.x, y: y - center.y)
        let rotated = translated.rotated(by: angle)
        return Self(x: rotated.x + center.x, y: rotated.y + center.y)
    }

    /// Rotate this point around the origin by an angle in degrees
    @inlinable
    public func rotated(by angle: Geometry<Double>.Degree) -> Self {
        rotated(by: angle.radians)
    }

    /// Rotate this point around a center point by an angle in degrees
    @inlinable
    public func rotated(by angle: Geometry<Double>.Degree, around center: Self) -> Self {
        rotated(by: angle.radians, around: center)
    }
}

// MARK: - Rotation (Float)

extension Geometry<Float>.Point where N == 2 {
    /// Rotate this point around the origin by an angle
    @inlinable
    public func rotated(by angle: Geometry<Float>.Radian) -> Self {
        let c = angle.cos
        let s = angle.sin
        return Self(x: x * c - y * s, y: x * s + y * c)
    }

    /// Rotate this point around a center point by an angle
    @inlinable
    public func rotated(by angle: Geometry<Float>.Radian, around center: Self) -> Self {
        let translated = Self(x: x - center.x, y: y - center.y)
        let rotated = translated.rotated(by: angle)
        return Self(x: rotated.x + center.x, y: rotated.y + center.y)
    }

    /// Rotate this point around the origin by an angle in degrees
    @inlinable
    public func rotated(by angle: Geometry<Float>.Degree) -> Self {
        rotated(by: angle.radians)
    }

    /// Rotate this point around a center point by an angle in degrees
    @inlinable
    public func rotated(by angle: Geometry<Float>.Degree, around center: Self) -> Self {
        rotated(by: angle.radians, around: center)
    }
}
