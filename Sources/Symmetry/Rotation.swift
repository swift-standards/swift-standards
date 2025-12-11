// Rotation.swift
// An N-dimensional rotation (element of SO(n), dimensionless).

public import Algebra_Linear
public import Angle

/// An N-dimensional rotation in Euclidean space.
///
/// Represents an element of SO(n), the special orthogonal group. Rotations are dimensionless angular displacements stored as orthogonal matrices with determinant +1, making them independent of coordinate system units.
///
/// ## Example
///
/// ```swift
/// let rotation = Rotation<2>(angle: .pi / 4)
/// let matrix = rotation.matrix
/// // [[cos(π/4), -sin(π/4)],
/// //  [sin(π/4),  cos(π/4)]]
/// ```
public struct Rotation<let N: Int>: Sendable {
    /// Orthogonal matrix representation with determinant +1.
    public var matrix: Linear<Double>.Matrix<N, N>

    /// Creates a rotation from an orthogonal matrix.
    ///
    /// - Precondition: Matrix must be orthogonal with determinant +1 (not validated).
    @inlinable
    public init(matrix: Linear<Double>.Matrix<N, N>) {
        self.matrix = matrix
    }
}

// MARK: - Equatable (2D)
// Rotation uses Linear<N> which has manual conformances for N == 2

extension Rotation: Equatable where N == 2 {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.matrix == rhs.matrix
    }
}

// MARK: - Hashable (2D)

extension Rotation: Hashable where N == 2 {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(matrix)
    }
}

// MARK: - Codable (2D)

#if Codable
    extension Rotation: Codable where N == 2 {
        private enum CodingKeys: String, CodingKey {
            case matrix
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let matrix = try container.decode(Linear<Double>.Matrix<2, 2>.self, forKey: .matrix)
            self.init(matrix: matrix)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(matrix, forKey: .matrix)
        }
    }
#endif

// MARK: - Identity

extension Rotation {
    /// Identity rotation representing no angular displacement.
    @inlinable
    public static var identity: Self {
        Self(matrix: .identity)
    }
}

// MARK: - 2D Rotation

extension Rotation where N == 2 {
    /// Rotation angle in radians.
    @inlinable
    public var angle: Radian {
        get { matrix.rotationAngle }
        set { self = Self(angle: newValue) }
    }

    /// Creates a 2D rotation from an angle in radians.
    @inlinable
    public init(angle: Radian) {
        let c = angle.cos
        let s = angle.sin
        self.init(matrix: .init(a: c, b: -s, c: s, d: c))
    }

    /// Creates a 2D rotation from an angle in degrees.
    @inlinable
    public init(degrees: Degree) {
        self.init(angle: degrees.radians)
    }

    /// Creates a 2D rotation from precomputed cosine and sine values.
    @inlinable
    public init(cos: Double, sin: Double) {
        self.init(matrix: .init(a: cos, b: -sin, c: sin, d: cos))
    }
}

// MARK: - Composition

extension Rotation {
    /// Composes two rotations by matrix multiplication.
    ///
    /// - Returns: Rotation applying `other` first, then `self`.
    @inlinable
    public func concatenating(_ other: Self) -> Self where N == 2 {
        Self(matrix: matrix.multiplied(by: other.matrix))
    }
}

extension Rotation where N == 2 {
    /// Inverse rotation (matrix transpose for orthogonal matrices).
    @inlinable
    public var inverted: Self {
        // For 2D: transpose is simple (inverse = transpose for orthogonal matrices)
        Self(matrix: matrix.transpose)
    }
}

// MARK: - 2D Convenience Operations

extension Rotation where N == 2 {
    /// Rotates by an additional angle in radians.
    @inlinable
    public func rotated(by angle: Radian) -> Self {
        concatenating(Self(angle: angle))
    }

    /// Rotates by an additional angle in degrees.
    @inlinable
    public func rotated(by degrees: Degree) -> Self {
        rotated(by: degrees.radians)
    }
}

// MARK: - Common 2D Rotations

extension Rotation where N == 2 {
    /// 90-degree counter-clockwise rotation.
    public static var quarterTurn: Self {
        Self(angle: .halfPi)
    }

    /// 180-degree rotation.
    public static var halfTurn: Self {
        Self(angle: .pi)
    }

    /// 90-degree clockwise rotation.
    public static var quarterTurnClockwise: Self {
        Self(angle: -.halfPi)
    }
}
