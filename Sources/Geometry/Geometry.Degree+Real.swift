// Degree+Real.swift
// Real-dependent extensions for Degree.

public import RealModule

extension Geometry.Degree where Unit: Real {
    /// Create a degree angle from a radian angle
    @inlinable
    public init(radians: Geometry<Unit>.Radian) {
        self.init(radians.value * 180 / Unit.pi)
    }

    /// Convert degrees to radians
    @inlinable
    public var radians: Geometry<Unit>.Radian {
        .init(degrees: self)
    }

    /// Sine of the angle
    @inlinable
    public var sin: Unit { radians.sin }

    /// Cosine of the angle
    @inlinable
    public var cos: Unit { radians.cos }

    /// Tangent of the angle
    @inlinable
    public var tan: Unit { radians.tan }
}

extension Geometry.Degree where Unit: Real {
    /// 90 degrees (right angle)
    @inlinable
    public static var rightAngle: Self { Self(90) }

    /// 180 degrees (straight angle)
    @inlinable
    public static var straight: Self { Self(180) }

    /// 360 degrees (full circle)
    @inlinable
    public static var fullCircle: Self { Self(360) }

    /// 45 degrees
    @inlinable
    public static var fortyFive: Self { Self(45) }

    /// 60 degrees
    @inlinable
    public static var sixty: Self { Self(60) }

    /// 30 degrees
    @inlinable
    public static var thirty: Self { Self(30) }
}
