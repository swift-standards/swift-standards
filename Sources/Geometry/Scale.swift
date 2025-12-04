// Scale.swift
// An N-dimensional scale transformation (dimensionless).

/// An N-dimensional scale transformation.
///
/// Scale factors are dimensionless - they represent ratios by which
/// coordinates are multiplied. A scale of 2 doubles the size regardless
/// of whether you're working in points, pixels, or meters.
///
/// ## Example
///
/// ```swift
/// let uniform = Scale<2>.uniform(2.0)      // 2x in both dimensions
/// let nonUniform = Scale<2>(x: 1.5, y: 2.0) // different per axis
/// ```
public struct Scale<let N: Int>: Sendable {
    /// The scale factors for each dimension
    public var factors: InlineArray<N, Double>

    /// Create a scale from an array of factors
    @inlinable
    public init(_ factors: consuming InlineArray<N, Double>) {
        self.factors = factors
    }
}

// MARK: - Equatable (2D)
// Note: InlineArray doesn't yet conform to Equatable/Hashable/Codable in Swift 6.2
// These conformances are planned for future Swift releases. For now, we implement
// manual conformances for the 2D case which is our primary use case.

extension Scale: Equatable where N == 2 {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

// MARK: - Hashable (2D)

extension Scale: Hashable where N == 2 {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

// MARK: - Codable (2D)

extension Scale: Codable where N == 2 {
    private enum CodingKeys: String, CodingKey {
        case x, y
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(Double.self, forKey: .x)
        let y = try container.decode(Double.self, forKey: .y)
        self.init(x: x, y: y)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
}

// MARK: - Subscript

extension Scale {
    /// Access scale factor by dimension index
    @inlinable
    public subscript(index: Int) -> Double {
        get { factors[index] }
        set { factors[index] = newValue }
    }
}

// MARK: - Identity and Presets

extension Scale {
    /// Identity scale (no scaling, all factors = 1)
    @inlinable
    public static var identity: Self {
        Self(InlineArray(repeating: 1.0))
    }

    /// Create a uniform scale (same factor in all dimensions)
    @inlinable
    public static func uniform(_ factor: Double) -> Self {
        Self(InlineArray(repeating: factor))
    }

    /// Double scale (2x in all dimensions)
    @inlinable
    public static var double: Self {
        Self(InlineArray(repeating: 2.0))
    }

    /// Half scale (0.5x in all dimensions)
    @inlinable
    public static var half: Self {
        Self(InlineArray(repeating: 0.5))
    }
}

// MARK: - 2D Convenience

extension Scale where N == 2 {
    /// The x scale factor
    @inlinable
    public var x: Double {
        get { factors[0] }
        set { factors[0] = newValue }
    }

    /// The y scale factor
    @inlinable
    public var y: Double {
        get { factors[1] }
        set { factors[1] = newValue }
    }

    /// Create a 2D scale with the given factors
    @inlinable
    public init(x: Double, y: Double) {
        self.init([x, y])
    }
}

// MARK: - 3D Convenience

extension Scale where N == 3 {
    /// The x scale factor
    @inlinable
    public var x: Double {
        get { factors[0] }
        set { factors[0] = newValue }
    }

    /// The y scale factor
    @inlinable
    public var y: Double {
        get { factors[1] }
        set { factors[1] = newValue }
    }

    /// The z scale factor
    @inlinable
    public var z: Double {
        get { factors[2] }
        set { factors[2] = newValue }
    }

    /// Create a 3D scale with the given factors
    @inlinable
    public init(x: Double, y: Double, z: Double) {
        self.init([x, y, z])
    }
}

// MARK: - Composition

extension Scale {
    /// Compose two scales (multiply factors component-wise)
    @inlinable
    public func concatenating(_ other: Self) -> Self {
        var result = factors
        for i in 0..<N {
            result[i] = factors[i] * other.factors[i]
        }
        return Self(result)
    }

    /// The inverse scale (1/factor for each dimension)
    @inlinable
    public var inverted: Self {
        var result = factors
        for i in 0..<N {
            result[i] = 1.0 / factors[i]
        }
        return Self(result)
    }
}

// MARK: - Conversion to Linear

extension Scale where N == 2 {
    /// Convert to a 2D linear transformation matrix
    @inlinable
    public var linear: Linear<2> {
        Linear(a: x, b: 0, c: 0, d: y)
    }
}
