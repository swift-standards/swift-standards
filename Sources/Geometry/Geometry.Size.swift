// Size.swift
// A fixed-size dimensions with compile-time known number of dimensions.

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
    /// let pageSize: Geometry.Size<2> = .init(width: 612, height: 792)
    /// let boxSize: Geometry.Size<3, Double> = .init(width: 10, height: 20, depth: 30)
    /// ```
    public struct Size<let N: Int> {
        /// The size dimensions stored inline
        public var dimensions: InlineArray<N, Unit>

        /// Create a size from an inline array of dimensions
        @inlinable
        public init(_ dimensions: consuming InlineArray<N, Unit>) {
            self.dimensions = dimensions
        }
    }
}

extension Geometry.Size: Sendable where Unit: Sendable {}

// MARK: - Equatable

extension Geometry.Size: Equatable where Unit: Equatable {
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

extension Geometry.Size: Hashable where Unit: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<N {
            hasher.combine(dimensions[i])
        }
    }
}

// MARK: - Typealiases

extension Geometry {
    /// A 2D size
    public typealias Size2 = Size<2>

    /// A 3D size
    public typealias Size3 = Size<3>
}

// MARK: - Codable

extension Geometry.Size: Codable where Unit: Codable {
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var dimensions = InlineArray<N, Unit>(repeating: try container.decode(Unit.self))
        for i in 1..<N {
            dimensions[i] = try container.decode(Unit.self)
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

// MARK: - Subscript

extension Geometry.Size {
    /// Access dimension by index
    @inlinable
    public subscript(index: Int) -> Unit {
        get { dimensions[index] }
        set { dimensions[index] = newValue }
    }
}

// MARK: - Functorial Map

extension Geometry.Size {
    /// Create a size by transforming each dimension of another size
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Size<N>, _ transform: (U) -> Unit) {
        var dims = InlineArray<N, Unit>(repeating: transform(other.dimensions[0]))
        for i in 1..<N {
            dims[i] = transform(other.dimensions[i])
        }
        self.init(dims)
    }

    /// Transform each dimension using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Size<N> {
        var result = InlineArray<N, Result>(repeating: try transform(dimensions[0]))
        for i in 1..<N {
            result[i] = try transform(dimensions[i])
        }
        return Geometry<Result>.Size<N>(result)
    }
}

// MARK: - Zero

extension Geometry.Size where Unit: AdditiveArithmetic {
    /// Zero size (all dimensions zero)
    @inlinable
    public static var zero: Self {
        Self(InlineArray(repeating: .zero))
    }
}

// MARK: - 2D Convenience

extension Geometry.Size where N == 2 {
    /// Width (first dimension)
    @inlinable
    public var width: Unit {
        get { dimensions[0] }
        set { dimensions[0] = newValue }
    }

    /// Height (second dimension)
    @inlinable
    public var height: Unit {
        get { dimensions[1] }
        set { dimensions[1] = newValue }
    }

    /// Create a 2D size with the given dimensions
    @inlinable
    public init(width: Unit, height: Unit) {
        self.init([width, height])
    }

    /// Create a 2D size from typed Width and Height values
    @inlinable
    public init(_ width: Geometry.Width, _ height: Geometry.Height) {
        self.init([width.value, height.value])
    }

    /// The width as a typed Width value
    @inlinable
    public var widthValue: Geometry.Width {
        Geometry.Width(width)
    }

    /// The height as a typed Height value
    @inlinable
    public var heightValue: Geometry.Height {
        Geometry.Height(height)
    }
}

// MARK: - 3D Convenience

extension Geometry.Size where N == 3 {
    /// Width (first dimension)
    @inlinable
    public var width: Unit {
        get { dimensions[0] }
        set { dimensions[0] = newValue }
    }

    /// Height (second dimension)
    @inlinable
    public var height: Unit {
        get { dimensions[1] }
        set { dimensions[1] = newValue }
    }

    /// Depth (third dimension)
    @inlinable
    public var depth: Unit {
        get { dimensions[2] }
        set { dimensions[2] = newValue }
    }

    /// Create a 3D size with the given dimensions
    @inlinable
    public init(width: Unit, height: Unit, depth: Unit) {
        self.init([width, height, depth])
    }

    /// Create a 3D size from a 2D size with depth
    @inlinable
    public init(_ size2: Geometry.Size<2>, depth: Unit) {
        self.init(width: size2.width, height: size2.height, depth: depth)
    }
}

// MARK: - Zip

extension Geometry.Size {
    /// Combine two sizes component-wise
    @inlinable
    public static func zip(_ a: Self, _ b: Self, _ combine: (Unit, Unit) -> Unit) -> Self {
        var result = a.dimensions
        for i in 0..<N {
            result[i] = combine(a.dimensions[i], b.dimensions[i])
        }
        return Self(result)
    }
}
