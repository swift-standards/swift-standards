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
