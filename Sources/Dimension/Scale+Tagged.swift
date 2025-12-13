// Scale+Tagged.swift
// Operators for scaling Tagged displacement, extent, and magnitude types.

// MARK: - Tagged × Scale<1> (Uniform Scaling)

// Displacement, Extent, and Magnitude can be scaled by dimensionless scale factors.
// Coordinates (positions) cannot be scaled - only vectors can.
// Using Scale<1, Scalar> makes the scaling operation explicit in the type system.

// MARK: Displacement.X × Scale

/// Scales an X displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales an X displacement by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales an X displacement by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales an X displacement by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides an X displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides an X displacement by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Displacement.Y × Scale

/// Scales a Y displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a Y displacement by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a Y displacement by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a Y displacement by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a Y displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a Y displacement by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Displacement.Z × Scale

/// Scales a Z displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a Z displacement by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a Z displacement by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a Z displacement by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a Z displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a Z displacement by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Extent.X × Scale

/// Scales an X extent (width) by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Extent.X<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.X<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales an X extent (width) by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Extent.X<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.X<Space>, Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales an X extent by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Extent.X<Space>, Scalar>
) -> Tagged<Extent.X<Space>, Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales an X extent by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Extent.X<Space>, Scalar>
) -> Tagged<Extent.X<Space>, Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides an X extent by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Extent.X<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.X<Space>, Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides an X extent by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Extent.X<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.X<Space>, Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Extent.Y × Scale

/// Scales a Y extent (height) by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Extent.Y<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.Y<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a Y extent (height) by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Extent.Y<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a Y extent by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Extent.Y<Space>, Scalar>
) -> Tagged<Extent.Y<Space>, Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a Y extent by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Extent.Y<Space>, Scalar>
) -> Tagged<Extent.Y<Space>, Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a Y extent by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Extent.Y<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.Y<Space>, Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a Y extent by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Extent.Y<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Extent.Z × Scale

/// Scales a Z extent (depth) by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Extent.Z<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.Z<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a Z extent (depth) by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Extent.Z<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a Z extent by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Extent.Z<Space>, Scalar>
) -> Tagged<Extent.Z<Space>, Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a Z extent by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Extent.Z<Space>, Scalar>
) -> Tagged<Extent.Z<Space>, Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a Z extent by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Extent.Z<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.Z<Space>, Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a Z extent by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Extent.Z<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Extent.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Magnitude × Scale

/// Scales a magnitude by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Magnitude<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a magnitude by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Magnitude<Space>, Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a magnitude by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Magnitude<Space>, Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a magnitude by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Magnitude<Space>, Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a magnitude by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Magnitude<Space>, Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a magnitude by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Scale<1, Scalar>
) -> Tagged<Magnitude<Space>, Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}
