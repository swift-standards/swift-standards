// Depth.swift
// A type-safe general linear measurement.

extension Geometry {
    /// A general linear measurement (length) parameterized by unit type.
    ///
    /// Use `Depth` for measurements that aren't specifically horizontal or vertical,
    /// such as distances, radii, or line thicknesses.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func drawCircle(center: Geometry<Points, Void>.Point<2>, radius: Geometry<Points, Void>.Depth) {
    ///     // ...
    /// }
    /// ```
    public struct Depth {
        /// The length value
        public var value: Scalar

        /// Create a length with the given value
        @inlinable
        public init(_ value: consuming Scalar) {
            self.value = value
        }
    }
}

extension Geometry.Depth: Sendable where Scalar: Sendable {}
extension Geometry.Depth: Equatable where Scalar: Equatable {}
extension Geometry.Depth: Hashable where Scalar: Hashable {}

// MARK: - Codable
#if Codable
    extension Geometry.Depth: Codable where Scalar: Codable {}
#endif
// MARK: - AdditiveArithmetic

extension Geometry.Depth where Scalar: AdditiveArithmetic {
    @inlinable
    public static var zero: Self {
        Self(.zero)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Depth: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.value = Scalar(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Depth: ExpressibleByFloatLiteral where Scalar: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.value = Scalar(floatLiteral: value)
    }
}

// MARK: - Strideable

extension Geometry.Depth: Strideable where Scalar: Strideable {
    public typealias Stride = Scalar.Stride

    @inlinable
    public func distance(to other: Self) -> Stride {
        value.distance(to: other.value)
    }

    @inlinable
    public func advanced(by n: Stride) -> Self {
        Self(value.advanced(by: n))
    }
}

// MARK: - Functorial Map

extension Geometry.Depth {
    /// Create a Depth by transforming the value of another Depth
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Geometry<U, Space>.Depth,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        self.init(try transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Geometry<Result, Space>.Depth {
        Geometry<Result, Space>.Depth(try transform(value))
    }
}
