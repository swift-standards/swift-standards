// Geometry.AffineTransform+Symmetry.swift
// AffineTransform initializers from Symmetry types.

public import Affine
import Geometry

// MARK: - AffineTransform from Rotation

extension Affine.Transform where Scalar == Double {
    /// Creates an affine transform from a 2D rotation.
    @inlinable
    public init(_ rotation: Rotation<2>) {
        self.init(linear: rotation.matrix, translation: .zero)
    }

    /// Creates an affine transform from a 2D scale.
    @inlinable
    public init(_ scale: Scale<2>) {
        self.init(linear: scale.linear, translation: .zero)
    }

    /// Creates an affine transform from a 2D shear.
    @inlinable
    public init(_ shear: Shear<2>) {
        self.init(linear: shear.linear, translation: .zero)
    }
}
