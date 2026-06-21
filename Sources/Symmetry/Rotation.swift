// Rotation.swift
// An N-dimensional rotation (element of SO(n), dimensionless).

public import Algebra_Linear
public import Dimension
public import RealModule

/// An N-dimensional rotation in Euclidean space.
///
/// Represents an element of SO(n), the special orthogonal group. Rotations are dimensionless
/// angular displacements stored as orthogonal matrices with determinant +1, making them
/// independent of coordinate system units.
///
/// ## Example
///
/// ```swift
/// let rotation = Rotation<2, Double>(angle: .pi / 4)
/// let matrix = rotation.linear()
/// // [[cos(π/4), -sin(π/4)],
/// //  [sin(π/4),  cos(π/4)]]
/// ```
public struct Rotation<let N: Int, Scalar> {
    /// Orthogonal matrix representation with determinant +1.
    public var matrix: InlineArray<N, InlineArray<N, Scalar>>

    /// Creates a rotation from an orthogonal matrix.
    ///
    /// - Precondition: Matrix must be orthogonal with determinant +1 (not validated).
    @inlinable
    public init(matrix: consuming InlineArray<N, InlineArray<N, Scalar>>) {
        self.matrix = matrix
    }
}

extension Rotation: Sendable where Scalar: Sendable {}

// MARK: - Equatable (2D)

extension Rotation: Equatable where N == 2, Scalar: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.matrix[0][0] == rhs.matrix[0][0] && lhs.matrix[0][1] == rhs.matrix[0][1]
            && lhs.matrix[1][0] == rhs.matrix[1][0] && lhs.matrix[1][1] == rhs.matrix[1][1]
    }
}

// MARK: - Hashable (2D)

extension Rotation: Hashable where N == 2, Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(matrix[0][0])
        hasher.combine(matrix[0][1])
        hasher.combine(matrix[1][0])
        hasher.combine(matrix[1][1])
    }
}

// MARK: - Codable (2D)

#if !hasFeature(Embedded)
    extension Rotation: Codable where N == 2, Scalar: Codable, Scalar: BinaryFloatingPoint {
        private enum CodingKeys: String, CodingKey {
            case a, b, c, d
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let a = try container.decode(Scalar.self, forKey: .a)
            let b = try container.decode(Scalar.self, forKey: .b)
            let c = try container.decode(Scalar.self, forKey: .c)
            let d = try container.decode(Scalar.self, forKey: .d)
            var m = InlineArray<2, InlineArray<2, Scalar>>(
                repeating: InlineArray<2, Scalar>(repeating: .zero)
            )
            m[0][0] = a
            m[0][1] = b
            m[1][0] = c
            m[1][1] = d
            self.init(matrix: m)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(matrix[0][0], forKey: .a)
            try container.encode(matrix[0][1], forKey: .b)
            try container.encode(matrix[1][0], forKey: .c)
            try container.encode(matrix[1][1], forKey: .d)
        }
    }
#endif

// MARK: - Identity

extension Rotation where Scalar: ExpressibleByIntegerLiteral {
    /// Identity rotation representing no angular displacement.
    @inlinable
    public static var identity: Self {
        var m = InlineArray<N, InlineArray<N, Scalar>>(
            repeating: InlineArray<N, Scalar>(repeating: 0)
        )
        for i in 0..<N {
            m[i][i] = 1
        }
        return Self(matrix: m)
    }
}

// MARK: - Conversion to Linear

extension Rotation where N == 2, Scalar: ExpressibleByIntegerLiteral {
    /// Converts to a 2D linear transformation matrix.
    @inlinable
    public func linear<Space>() -> Linear<Scalar, Space>.Matrix<2, 2> {
        .init(a: matrix[0][0], b: matrix[0][1], c: matrix[1][0], d: matrix[1][1])
    }
}

// MARK: - 2D Rotation

extension Rotation where N == 2, Scalar: Real {
    /// Rotation angle in radians.
    public var angle: Radian<Scalar> {
        get { Radian(Scalar.atan2(y: matrix[1][0], x: matrix[0][0])) }
        set { self = Self(angle: newValue) }
    }
}

extension Rotation where N == 2, Scalar: Real {
    /// Creates a 2D rotation from an angle in radians.
    @inlinable
    public init(angle: Radian<Scalar>) {
        let c = angle.cos.value
        let s = angle.sin.value
        var m = InlineArray<2, InlineArray<2, Scalar>>(
            repeating: InlineArray<2, Scalar>(repeating: .zero)
        )
        m[0][0] = c
        m[0][1] = -s
        m[1][0] = s
        m[1][1] = c
        self.init(matrix: m)
    }
}

extension Rotation where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Creates a 2D rotation from an angle in degrees.
    @inlinable
    public init(degrees: Degree<Scalar>) {
        self.init(angle: degrees.radians)
    }
}

extension Rotation where N == 2, Scalar: Real {
    /// Creates a 2D rotation from precomputed cosine and sine values.
    @inlinable
    public init(cos: Scalar, sin: Scalar) {
        var m = InlineArray<2, InlineArray<2, Scalar>>(
            repeating: InlineArray<2, Scalar>(repeating: .zero)
        )
        m[0][0] = cos
        m[0][1] = -sin
        m[1][0] = sin
        m[1][1] = cos
        self.init(matrix: m)
    }
}

// MARK: - Composition

extension Rotation where N == 2, Scalar: BinaryFloatingPoint {
    /// Static composition: Multiplies two rotation matrices.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand side rotation
    ///   - rhs: Right-hand side rotation to apply first
    /// - Returns: Result of matrix multiplication (rhs applied first, then lhs)
    @inlinable
    public static func concatenate(
        _ lhs: Self,
        with rhs: Self
    ) -> Self {
        // 2x2 matrix multiplication
        let a = lhs.matrix[0][0] * rhs.matrix[0][0] + lhs.matrix[0][1] * rhs.matrix[1][0]
        let b = lhs.matrix[0][0] * rhs.matrix[0][1] + lhs.matrix[0][1] * rhs.matrix[1][1]
        let c = lhs.matrix[1][0] * rhs.matrix[0][0] + lhs.matrix[1][1] * rhs.matrix[1][0]
        let d = lhs.matrix[1][0] * rhs.matrix[0][1] + lhs.matrix[1][1] * rhs.matrix[1][1]
        var m = InlineArray<2, InlineArray<2, Scalar>>(
            repeating: InlineArray<2, Scalar>(repeating: .zero)
        )
        m[0][0] = a
        m[0][1] = b
        m[1][0] = c
        m[1][1] = d
        return Self(matrix: m)
    }
}

extension Rotation where N == 2, Scalar: BinaryFloatingPoint {
    /// Composes two rotations by matrix multiplication.
    ///
    /// - Returns: Rotation applying `other` first, then `self`.
    @inlinable
    public func concatenating(_ other: Self) -> Self {
        Self.concatenate(self, with: other)
    }
}

extension Rotation where N == 2, Scalar: BinaryFloatingPoint {
    /// Static inversion: Computes the inverse rotation (transpose for orthogonal matrices).
    ///
    /// - Parameter rotation: The rotation to invert
    /// - Returns: Inverse rotation with transposed matrix
    @inlinable
    public static func inverted(_ rotation: Self) -> Self {
        // For 2D: transpose (inverse = transpose for orthogonal matrices)
        var m = InlineArray<2, InlineArray<2, Scalar>>(
            repeating: InlineArray<2, Scalar>(repeating: .zero)
        )
        m[0][0] = rotation.matrix[0][0]
        m[0][1] = rotation.matrix[1][0]
        m[1][0] = rotation.matrix[0][1]
        m[1][1] = rotation.matrix[1][1]
        return Self(matrix: m)
    }
}

extension Rotation where N == 2, Scalar: BinaryFloatingPoint {
    /// Inverse rotation (matrix transpose for orthogonal matrices).
    @inlinable
    public var inverted: Self {
        Self.inverted(self)
    }
}

// MARK: - 2D Convenience Operations

extension Rotation where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Rotates by an additional angle in radians.
    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        concatenating(Self(angle: angle))
    }
}

extension Rotation where N == 2, Scalar: Real & BinaryFloatingPoint {
    /// Rotates by an additional angle in degrees.
    @inlinable
    public func rotated(by degrees: Degree<Scalar>) -> Self {
        rotated(by: degrees.radians)
    }
}

// MARK: - Common 2D Rotations

extension Rotation where N == 2, Scalar: Real {
    /// 90-degree counter-clockwise rotation.
    @inlinable
    public static var quarterTurn: Self {
        Self(angle: Radian<Scalar>(Scalar.pi / 2))
    }
}

extension Rotation where N == 2, Scalar: Real {
    /// 180-degree rotation.
    @inlinable
    public static var halfTurn: Self {
        Self(angle: Radian<Scalar>(Scalar.pi))
    }
}

extension Rotation where N == 2, Scalar: Real {
    /// 90-degree clockwise rotation.
    @inlinable
    public static var quarterTurnClockwise: Self {
        Self(angle: Radian<Scalar>(-Scalar.pi / 2))
    }
}
