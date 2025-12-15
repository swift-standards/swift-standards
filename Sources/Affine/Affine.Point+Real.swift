// Affine.Point+Real.swift
// Polar coordinates and rotation for 2D points with Real scalar types.

import Algebra_Linear
public import Dimension
public import RealModule

// MARK: - Polar Coordinates

extension Affine.Point where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Creates point at polar coordinates relative to origin.
    ///
    /// Converts polar coordinates `(r, θ)` to Cartesian coordinates `(x, y)`.
    /// Point at origin + radial offset: Coordinate(0) + Magnitude = Coordinate
    @inlinable
    public static func polar(radius: Affine.Distance, angle: Radian<Scalar>) -> Self {
        Self(
            x: Affine.X.zero + radius * angle.cos,
            y: Affine.Y.zero + radius * angle.sin
        )
    }

    /// Angular direction from origin to this point in radians.
    @inlinable
    public var angle: Radian<Scalar> {
        Radian(Scalar.atan2(y: y._rawValue, x: x._rawValue))
    }

    /// Distance from origin to this point.
    @inlinable
    public var radius: Affine.Distance {
        // sqrt(x² + y²) using raw values since coordinates can't be multiplied
        Affine.Distance(Scalar.sqrt(x._rawValue * x._rawValue + y._rawValue * y._rawValue))
    }
}

// MARK: - Rotation

extension Affine.Point where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Rotates point counterclockwise around origin by specified angle.
    @inlinable
    public static func rotated(
        _ point: Self,
        by angle: Radian<Scalar>
    ) -> Self {
        let c = angle.cos.value
        let s = angle.sin.value
        let px = point.x._rawValue
        let py = point.y._rawValue
        return Self(
            x: Affine.X(px * c - py * s),
            y: Affine.Y(px * s + py * c)
        )
    }

    /// Rotates point counterclockwise around origin by specified angle.
    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    /// Rotates point counterclockwise around specified center by angle.
    @inlinable
    public static func rotated(_ point: Self, by angle: Radian<Scalar>, around center: Self) -> Self {
        // Translate to origin: Point - Center = Displacement, then make point at origin + displacement
        let dx = point.x - center.x  // Displacement.X
        let dy = point.y - center.y  // Displacement.Y
        let translated = Self(
            x: Affine.X.zero + dx,
            y: Affine.Y.zero + dy
        )
        let rotated = Self.rotated(translated, by: angle)
        // Translate back: rotated point's position as displacement from origin, added to center
        let rdx = rotated.x - Affine.X.zero  // Displacement.X
        let rdy = rotated.y - Affine.Y.zero  // Displacement.Y
        return Self(
            x: center.x + rdx,
            y: center.y + rdy
        )
    }

    /// Rotates point counterclockwise around specified center by angle.
    @inlinable
    public func rotated(by angle: Radian<Scalar>, around center: Self) -> Self {
        Self.rotated(self, by: angle, around: center)
    }

    /// Rotates point counterclockwise around origin by angle in degrees.
    @inlinable
    public static func rotated(_ point: Self, by angle: Degree<Scalar>) -> Self {
        rotated(point, by: angle.radians)
    }

    /// Rotates point counterclockwise around origin by angle in degrees.
    @inlinable
    public func rotated(by angle: Degree<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    /// Rotates point counterclockwise around specified center by angle in degrees.
    @inlinable
    public static func rotated(_ point: Self, by angle: Degree<Scalar>, around center: Self) -> Self {
        rotated(point, by: angle.radians, around: center)
    }

    /// Rotates point counterclockwise around specified center by angle in degrees.
    @inlinable
    public func rotated(by angle: Degree<Scalar>, around center: Self) -> Self {
        Self.rotated(self, by: angle, around: center)
    }
}
