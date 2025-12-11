// Symmetry.swift
// Namespace for Lie group elements acting on Euclidean space.

/// Namespace for dimensionless geometric transformations.
///
/// Symmetry provides types representing Lie group elements that act on Euclidean space. All transformations are dimensionless—they use ratios and angles rather than absolute units, making them independent of coordinate system scale.
///
/// ## Example
///
/// ```swift
/// let rotation = Rotation<2>(angle: .pi / 4)
/// let scale = Scale<2>(x: 2.0, y: 1.5)
/// let shear = Shear<2>(x: 0.5, y: 0)
/// // (0, 1) rotated 45° → (-√2/2, √2/2)
/// ```
///
/// ## Types
///
/// - ``Rotation``: Elements of SO(n), the special orthogonal group
/// - ``Scale``: Diagonal scaling transformations forming (ℝ⁺)ⁿ
/// - ``Shear``: Off-diagonal shear transformations
///
/// ## Note
///
/// Together these types generate GL⁺(n), the orientation-preserving linear maps. When combined with translations they form the affine group Aff(n) = GL(n) ⋊ ℝⁿ.
public enum Symmetry {}
