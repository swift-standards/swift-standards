// Degree+Trigonometry.swift
// Degree constants.

public import RealModule

// MARK: - Constants

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
