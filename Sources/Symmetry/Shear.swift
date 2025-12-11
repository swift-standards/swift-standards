// Shear.swift
// An N-dimensional shear transformation (dimensionless).

public import Algebra_Linear

/// An N-dimensional shear transformation parameterized by scalar type.
///
/// Represents dimensionless shear factors that shift coordinates in one axis proportionally
/// to another axis. In 2D, shearing transforms rectangles into parallelograms while preserving area.
///
/// ## Example
///
/// ```swift
/// let shear = Shear<2, Double>(x: 0.5, y: 0)
/// // (1, 1) sheared → (1.5, 1)
/// // (0, 2) sheared → (1.0, 2)
/// ```
///
/// ## Note
///
/// For N dimensions, shear has N*(N-1) off-diagonal parameters. This implementation
/// focuses on 2D and 3D cases.
public struct Shear<let N: Int, Scalar: FloatingPoint> {
    /// Off-diagonal shear factors as an N×N matrix.
    public var factors: InlineArray<N, InlineArray<N, Scalar>>

    /// Creates a shear from a matrix of off-diagonal factors.
    @inlinable
    public init(_ factors: consuming InlineArray<N, InlineArray<N, Scalar>>) {
        self.factors = factors
    }
}

extension Shear: Sendable where Scalar: Sendable {}

// MARK: - Equatable (2D)

extension Shear: Equatable where N == 2 {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

// MARK: - Hashable (2D)

extension Shear: Hashable where N == 2, Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

// MARK: - Codable (2D)

#if Codable
    extension Shear: Codable where N == 2, Scalar: Codable {
        private enum CodingKeys: String, CodingKey {
            case x, y
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let x = try container.decode(Scalar.self, forKey: .x)
            let y = try container.decode(Scalar.self, forKey: .y)
            self.init(x: x, y: y)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(x, forKey: .x)
            try container.encode(y, forKey: .y)
        }
    }
#endif

// MARK: - Identity

extension Shear where Scalar: ExpressibleByIntegerLiteral {
    /// Identity shear with all off-diagonal factors equal to 0.
    @inlinable
    public static var identity: Self {
        Self(InlineArray(repeating: InlineArray(repeating: 0)))
    }
}

// MARK: - 2D Convenience

extension Shear where N == 2 {
    /// Shear factor for x displacement per unit y.
    @inlinable
    public var x: Scalar {
        get { factors[0][1] }
        set { factors[0][1] = newValue }
    }

    /// Shear factor for y displacement per unit x.
    @inlinable
    public var y: Scalar {
        get { factors[1][0] }
        set { factors[1][0] = newValue }
    }

    /// Creates a 2D shear with the given factors.
    ///
    /// - Parameters:
    ///   - x: Shear factor for x displacement per unit y
    ///   - y: Shear factor for y displacement per unit x
    @inlinable
    public init(x: Scalar, y: Scalar) where Scalar: ExpressibleByIntegerLiteral {
        var matrix = InlineArray<2, InlineArray<2, Scalar>>(
            repeating: InlineArray<2, Scalar>(repeating: 0)
        )
        matrix[0][1] = x  // shear x by y
        matrix[1][0] = y  // shear y by x
        self.init(matrix)
    }

    /// Creates a horizontal shear displacing x based on y.
    @inlinable
    public static func horizontal(_ factor: Scalar) -> Self
    where Scalar: ExpressibleByIntegerLiteral {
        Self(x: factor, y: 0)
    }

    /// Creates a vertical shear displacing y based on x.
    @inlinable
    public static func vertical(_ factor: Scalar) -> Self
    where Scalar: ExpressibleByIntegerLiteral {
        Self(x: 0, y: factor)
    }
}

// MARK: - Conversion to Linear

extension Shear where N == 2, Scalar: ExpressibleByIntegerLiteral {
    /// Converts to a 2D linear transformation matrix.
    @inlinable
    public func linear<Space>() -> Linear<Scalar, Space>.Matrix<2, 2> {
        .init(a: 1, b: x, c: y, d: 1)
    }
}
