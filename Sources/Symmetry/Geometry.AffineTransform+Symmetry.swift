// Geometry.AffineTransform+Symmetry.swift
// AffineTransform initializers from Symmetry types.

import Geometry
public import Affine

// MARK: - AffineTransform from Rotation

extension Affine.Transform where Scalar == Double {
    /// Create from a rotation
    @inlinable
    public init(_ rotation: Rotation<2>) {
        self.init(linear: rotation.matrix, translation: .zero)
    }

    /// Create from a scale
    @inlinable
    public init(_ scale: Scale<2>) {
        self.init(linear: scale.linear, translation: .zero)
    }

    /// Create from a shear
    @inlinable
    public init(_ shear: Shear<2>) {
        self.init(linear: shear.linear, translation: .zero)
    }
}
