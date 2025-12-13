// Tagged+ND.swift
// N-dimensional arithmetic operators for Tagged types with InlineArray.
// Uses role-first namespace structure: Displacement.Vector<N, Space>, Coordinate.Vector<N, Space>, etc.

// MARK: - Type Aliases

/// An N-dimensional vector (displacement) in affine space.
public typealias NDVector<let N: Int, Scalar, Space> = Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>

/// An N-dimensional point (position) in affine space.
public typealias NDPoint<let N: Int, Scalar, Space> = Tagged<Coordinate.Vector<N, Space>, InlineArray<N, Scalar>>

/// An N-dimensional size (extent).
public typealias NDSize<let N: Int, Scalar, Space> = Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>>

// MARK: - Vector + Vector

/// Adds two N-dimensional vectors.
@inlinable
public func + <let N: Int, Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] + rhs._rawValue[i]
    }
    return Tagged(result)
}

/// Subtracts two N-dimensional vectors.
@inlinable
public func - <let N: Int, Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] - rhs._rawValue[i]
    }
    return Tagged(result)
}

// MARK: - Point + Vector / Point - Vector

/// Adds a vector to a point (translation).
@inlinable
public func + <let N: Int, Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Coordinate.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] + rhs._rawValue[i]
    }
    return Tagged(result)
}

/// Adds a point to a vector (commutative translation).
@inlinable
public func + <let N: Int, Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Coordinate.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Coordinate.Vector<N, Space>, InlineArray<N, Scalar>> {
    rhs + lhs
}

/// Subtracts a vector from a point (translation).
@inlinable
public func - <let N: Int, Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Coordinate.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] - rhs._rawValue[i]
    }
    return Tagged(result)
}

// MARK: - Point - Point = Vector

/// Subtracts two points, returning the displacement vector.
@inlinable
public func - <let N: Int, Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Coordinate.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] - rhs._rawValue[i]
    }
    return Tagged(result)
}

// MARK: - Size + Size / Size - Size

/// Adds two N-dimensional sizes.
@inlinable
public func + <let N: Int, Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] + rhs._rawValue[i]
    }
    return Tagged(result)
}

/// Subtracts two N-dimensional sizes.
@inlinable
public func - <let N: Int, Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] - rhs._rawValue[i]
    }
    return Tagged(result)
}

// MARK: - Vector Scaling (via same-type multiplication for ExpressibleByIntegerLiteral)

/// Multiplies an N-dimensional vector by another (element-wise), returning vector.
///
/// This enables `vector * 2` via ExpressibleByIntegerLiteral.
@inlinable
public func * <let N: Int, Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] * rhs._rawValue[i]
    }
    return Tagged(result)
}

/// Divides an N-dimensional vector by another (element-wise), returning vector.
///
/// This enables `vector / 2` via ExpressibleByIntegerLiteral.
@inlinable
public func / <let N: Int, Space, Scalar: FloatingPoint>(
    lhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] / rhs._rawValue[i]
    }
    return Tagged(result)
}

// MARK: - Size Scaling

/// Multiplies an N-dimensional size by another (element-wise).
@inlinable
public func * <let N: Int, Space, Scalar: Numeric>(
    lhs: Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] * rhs._rawValue[i]
    }
    return Tagged(result)
}

/// Divides an N-dimensional size by another (element-wise).
@inlinable
public func / <let N: Int, Space, Scalar: FloatingPoint>(
    lhs: Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>>,
    rhs: Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Extent.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = InlineArray<N, Scalar>(repeating: .zero)
    for i in 0..<N {
        result[i] = lhs._rawValue[i] / rhs._rawValue[i]
    }
    return Tagged(result)
}

// MARK: - Negation

/// Negates an N-dimensional vector.
@inlinable
public prefix func - <let N: Int, Space, Scalar: SignedNumeric>(
    value: Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>>
) -> Tagged<Displacement.Vector<N, Space>, InlineArray<N, Scalar>> {
    var result = value._rawValue
    for i in 0..<N {
        result[i] = -value._rawValue[i]
    }
    return Tagged(result)
}

// MARK: - Zero

extension Tagged where RawValue == InlineArray<2, Double> {
    /// The zero value.
    @inlinable
    public static var zero: Self { Self(InlineArray(repeating: .zero)) }
}

extension Tagged where RawValue == InlineArray<3, Double> {
    /// The zero value.
    @inlinable
    public static var zero: Self { Self(InlineArray(repeating: .zero)) }
}

extension Tagged where RawValue == InlineArray<4, Double> {
    /// The zero value.
    @inlinable
    public static var zero: Self { Self(InlineArray(repeating: .zero)) }
}

// MARK: - Subscript Access

extension Tagged {
    /// Access component by index.
    @inlinable
    public subscript<let N: Int, Element>(index: Int) -> Element
    where RawValue == InlineArray<N, Element> {
        get { _rawValue[index] }
        set { _rawValue[index] = newValue }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension Tagged: ExpressibleByArrayLiteral where RawValue == InlineArray<2, Double> {
    public init(arrayLiteral elements: Double...) {
        precondition(elements.count == 2, "Expected 2 elements")
        self.init([elements[0], elements[1]])
    }
}
