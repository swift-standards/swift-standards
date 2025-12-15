// Size.swift
// A fixed-size dimensions with compile-time known number of dimensions.

public import Algebra_Linear
public import Dimension

extension Geometry {
    /// A fixed-size dimensions with compile-time known number of dimensions.
    ///
    /// This generic structure represents N-dimensional sizes (width, height, depth, etc.)
    /// and can be specialized for different coordinate systems.
    ///
    /// Uses Swift 6.2 integer generic parameters (SE-0452) for type-safe
    /// dimension checking at compile time.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pageSize: Geometry<Double, Void>.Size<2, Void> = .init(
    ///     width: .init(612), height: .init(792)
    /// )
    /// ```
    public struct Size<let N: Int> {
        /// The size dimensions stored inline
        public var dimensions: InlineArray<N, Scalar>

        /// Create a size from an inline array of dimensions
        @inlinable
        public init(_ dimensions: consuming InlineArray<N, Scalar>) {
            self.dimensions = dimensions
        }
    }
}

extension Geometry.Size: Sendable where Scalar: Sendable {}

// MARK: - Equatable

extension Geometry.Size: Equatable where Scalar: Equatable {
    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for i in 0..<N {
            if lhs.dimensions[i] != rhs.dimensions[i] {
                return false
            }
        }
        return true
    }
}

// MARK: - Hashable

extension Geometry.Size: Hashable where Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<N {
            hasher.combine(dimensions[i])
        }
    }
}

// MARK: - Codable

#if Codable
    extension Geometry.Size: Codable where Scalar: Codable {
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var dimensions = InlineArray<N, Scalar>(repeating: try container.decode(Scalar.self))
            for i in 1..<N {
                dimensions[i] = try container.decode(Scalar.self)
            }
            self.dimensions = dimensions
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            for i in 0..<N {
                try container.encode(dimensions[i])
            }
        }
    }
#endif

// MARK: - Subscript

extension Geometry.Size {
    /// Access dimension by index
    @inlinable
    public subscript(index: Int) -> Scalar {
        get { dimensions[index] }
        set { dimensions[index] = newValue }
    }
}

// MARK: - Functorial Map

extension Geometry.Size {
    /// Create a size by transforming each dimension of another size
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Geometry<U, Space>.Size<N>,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        var dims = InlineArray<N, Scalar>(repeating: try transform(other.dimensions[0]))
        for i in 1..<N {
            dims[i] = try transform(other.dimensions[i])
        }
        self.init(dims)
    }

    /// Transform each dimension using the given closure
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Geometry<Result, Space>.Size<N> {
        var result = InlineArray<N, Result>(repeating: try transform(dimensions[0]))
        for i in 1..<N {
            result[i] = try transform(dimensions[i])
        }
        return Geometry<Result, Space>.Size<N>(result)
    }
}

// MARK: - AdditiveArithmetic

extension Geometry.Size where Scalar: AdditiveArithmetic {
    /// Zero size (all dimensions zero)
    @inlinable
    public static var zero: Self {
        Self(InlineArray(repeating: .zero))
    }
}

extension Geometry.Size where N == 1 {
    /// The single dimension as a Length (magnitude)
    @inlinable
    public var length: Geometry.Length {
        get { Geometry.Length(dimensions[0]) }
        set { dimensions[0] = newValue._rawValue }
    }

    /// Project as width (horizontal extent)
    @inlinable
    public var width: Geometry.Width {
        get { Geometry.Width(dimensions[0]) }
        set { dimensions[0] = newValue._rawValue }
    }

    /// Project as height (vertical extent)
    @inlinable
    public var height: Geometry.Height {
        get { Geometry.Height(dimensions[0]) }
        set { dimensions[0] = newValue._rawValue }
    }

    /// Create from a scalar value
    @inlinable
    public init(_ value: Scalar) {
        self.init([value])
    }
}

extension Geometry.Size where N == 1, Scalar: AdditiveArithmetic {
    /// Sum of both horizontal sides (for padding/margins applied to left and right)
    ///
    /// Equivalent to `width * 2`, useful for calculating total horizontal padding.
    @inlinable
    public var horizontal: Geometry.Width {
        Geometry.Width(dimensions[0] + dimensions[0])
    }

    /// Sum of both vertical sides (for padding/margins applied to top and bottom)
    ///
    /// Equivalent to `height * 2`, useful for calculating total vertical padding.
    @inlinable
    public var vertical: Geometry.Height {
        Geometry.Height(dimensions[0] + dimensions[0])
    }
}

// MARK: - 2D Convenience

extension Geometry.Size where N == 2 {
    /// Width (first dimension, type-safe)
    @inlinable
    public var width: Geometry.Width {
        get { Geometry.Width(dimensions[0]) }
        set { dimensions[0] = newValue._rawValue }
    }

    /// Height (second dimension, type-safe)
    @inlinable
    public var height: Geometry.Height {
        get { Geometry.Height(dimensions[1]) }
        set { dimensions[1] = newValue._rawValue }
    }

    /// Create a 2D size from typed Width and Height values
    @inlinable
    public init(width: Geometry.Width, height: Geometry.Height) {
        self.init([width._rawValue, height._rawValue])
    }
}

// MARK: - 3D Convenience

extension Geometry.Size where N == 3 {
    /// Width (first dimension)
    @inlinable
    public var width: Geometry.Width {
        get { .init(dimensions[0]) }
        set { dimensions[0] = newValue._rawValue }
    }

    /// Height (second dimension)
    @inlinable
    public var height: Geometry.Height {
        get { .init(dimensions[1]) }
        set { dimensions[1] = newValue._rawValue }
    }

    /// Depth (third dimension) - raw scalar as we don't have typed Dz
    @inlinable
    public var depth: Scalar {
        get { dimensions[2] }
        set { dimensions[2] = newValue }
    }

    /// Create a 3D size from typed values with raw depth
    @inlinable
    public init(width: Geometry.Width, height: Geometry.Height, depth: Scalar) {
        self.init([width._rawValue, height._rawValue, depth])
    }

    /// Create a 3D size from a 2D size with depth
    @inlinable
    public init(_ size2: Geometry.Size<2>, depth: Scalar) {
        self.init(width: size2.width, height: size2.height, depth: depth)
    }
}

// MARK: - Zip

extension Geometry.Size {
    /// Combine two sizes component-wise
    @inlinable
    public static func zip(_ a: Self, _ b: Self, _ combine: (Scalar, Scalar) -> Scalar) -> Self {
        var result = a.dimensions
        for i in 0..<N {
            result[i] = combine(a.dimensions[i], b.dimensions[i])
        }
        return Self(result)
    }
}

// MARK: - ExpressibleByLiteral for 1D Size

extension Geometry.Size: ExpressibleByIntegerLiteral where N == 1, Scalar: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.init([Scalar(integerLiteral: value)])
    }
}

extension Geometry.Size: ExpressibleByFloatLiteral where N == 1, Scalar: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.init([Scalar(floatLiteral: value)])
    }
}
