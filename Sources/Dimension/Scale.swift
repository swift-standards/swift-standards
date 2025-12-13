// Scale.swift
// An N-dimensional scale transformation (dimensionless).

/// An N-dimensional scale transformation parameterized by scalar type.
///
/// Represents dimensionless scaling factors that multiply coordinates. A scale of 2 doubles
/// size regardless of whether coordinates represent points, pixels, or meters, making it
/// independent of unit systems.
///
/// ## Example
///
/// ```swift
/// let uniform = Scale<2, Double>.uniform(2.0)
/// let stretch = Scale<2, Double>(x: 1.5, y: 2.0)
/// // (1, 1) stretched → (1.5, 2.0)
/// ```
public struct Scale<let N: Int, Scalar: FloatingPoint> {
    /// Scale factors for each dimension.
    public var factors: InlineArray<N, Scalar>

    /// Creates a scale from an array of factors.
    @inlinable
    public init(_ factors: consuming InlineArray<N, Scalar>) {
        self.factors = factors
    }
}

extension Scale: Sendable where Scalar: Sendable {}

// MARK: - Equatable

extension Scale: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        for i in 0..<N {
            if lhs.factors[i] != rhs.factors[i] { return false }
        }
        return true
    }
}

// MARK: - Hashable

extension Scale: Hashable where Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<N {
            hasher.combine(factors[i])
        }
    }
}

// MARK: - Codable

#if Codable
    extension Scale: Codable where Scalar: Codable {
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var factors = InlineArray<N, Scalar>(repeating: .zero)
            for i in 0..<N {
                factors[i] = try container.decode(Scalar.self)
            }
            self.init(factors)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            for i in 0..<N {
                try container.encode(factors[i])
            }
        }
    }
#endif

// MARK: - Subscript

extension Scale {
    /// Accesses scale factor by dimension index.
    @inlinable
    public subscript(index: Int) -> Scalar {
        get { factors[index] }
        set { factors[index] = newValue }
    }
}

// MARK: - Identity and Presets

extension Scale where Scalar: ExpressibleByIntegerLiteral {
    /// Identity scale with all factors equal to 1.
    @inlinable
    public static var identity: Self {
        Self(InlineArray(repeating: 1))
    }

    /// Creates a uniform scale with the same factor in all dimensions.
    @inlinable
    public static func uniform(_ factor: Scale<1, Scalar>) -> Self {
        Self(InlineArray(repeating: factor.value))
    }

    /// Uniform 2x scale in all dimensions.
    @inlinable
    public static var double: Self {
        Self(InlineArray(repeating: 2))
    }
}

extension Scale where Scalar: BinaryFloatingPoint {
    /// Uniform 0.5x scale in all dimensions.
    @inlinable
    public static var half: Self {
        Self(InlineArray(repeating: Scalar(0.5)))
    }
}

// MARK: - 1D Convenience

extension Scale where N == 1 {
    /// Scale factor value for 1D transformations.
    @inlinable
    public var value: Scalar {
        get { factors[0] }
        set { factors[0] = newValue }
    }

    /// Creates a 1D scale with the given factor.
    @inlinable
    public init(_ value: Scalar) {
        self.init([value])
    }
}

// MARK: - 2D Convenience

extension Scale where N == 2 {
    /// Scale factor for the x dimension.
    @inlinable
    public var x: Scalar {
        get { factors[0] }
        set { factors[0] = newValue }
    }

    /// Scale factor for the y dimension.
    @inlinable
    public var y: Scalar {
        get { factors[1] }
        set { factors[1] = newValue }
    }

    /// Creates a 2D scale with the given factors.
    @inlinable
    public init(x: Scalar, y: Scalar) {
        self.init([x, y])
    }
}

// MARK: - 3D Convenience

extension Scale where N == 3 {
    /// Scale factor for the x dimension.
    @inlinable
    public var x: Scalar {
        get { factors[0] }
        set { factors[0] = newValue }
    }

    /// Scale factor for the y dimension.
    @inlinable
    public var y: Scalar {
        get { factors[1] }
        set { factors[1] = newValue }
    }

    /// Scale factor for the z dimension.
    @inlinable
    public var z: Scalar {
        get { factors[2] }
        set { factors[2] = newValue }
    }

    /// Creates a 3D scale with the given factors.
    @inlinable
    public init(x: Scalar, y: Scalar, z: Scalar) {
        self.init([x, y, z])
    }
}

// MARK: - Composition

extension Scale {
    /// Static composition: Multiplies scale factors component-wise.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand side scale
    ///   - rhs: Right-hand side scale to apply first
    /// - Returns: Scale with component-wise multiplied factors
    @inlinable
    public static func concatenate(
        _ lhs: Self,
        with rhs: Self
    ) -> Self {
        var result = lhs.factors
        for i in 0..<N {
            result[i] = lhs.factors[i] * rhs.factors[i]
        }
        return Self(result)
    }

    /// Composes two scales by multiplying factors component-wise.
    @inlinable
    public func concatenating(_ other: Self) -> Self {
        Self.concatenate(self, with: other)
    }

    /// Static inversion: Computes the inverse scale with reciprocal factors.
    ///
    /// - Parameter scale: The scale to invert
    /// - Returns: Scale with reciprocal factors (1/factor per dimension)
    @inlinable
    public static func inverted(_ scale: Self) -> Self {
        var result = scale.factors
        for i in 0..<N {
            result[i] = 1 / scale.factors[i]
        }
        return Self(result)
    }

    /// Inverse scale with reciprocal factors (1/factor per dimension).
    @inlinable
    public var inverted: Self {
        Self.inverted(self)
    }
}

// MARK: - 1D Literals

extension Scale: ExpressibleByFloatLiteral where N == 1, Scalar: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Scalar.FloatLiteralType

    @inlinable
    public init(floatLiteral value: FloatLiteralType) {
        self.init(Scalar(floatLiteral: value))
    }
}

extension Scale: ExpressibleByIntegerLiteral where N == 1, Scalar: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Scalar.IntegerLiteralType

    @inlinable
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(Scalar(integerLiteral: value))
    }
}
