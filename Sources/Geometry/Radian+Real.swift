// Radian+Real.swift
// Real-dependent extensions for Radian.

public import RealModule

extension Geometry.Radian where Unit: Real {
    /// Create a radian angle from a degree angle
    @inlinable
    public init(degrees: Geometry<Unit>.Degree) {
        self.init(degrees.value * Unit.pi / 180)
    }

    /// Convert radians to degrees
    @inlinable
    public var degrees: Geometry<Unit>.Degree {
        .init(radians: self)
    }
}
