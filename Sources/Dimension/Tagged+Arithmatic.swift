//
//  File.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 13/12/2025.
//

// MARK: - Zero

// Note: We intentionally do NOT conform Tagged to AdditiveArithmetic.
// In affine geometry, Coordinate - Coordinate = Displacement (not Coordinate).
// Blanket +/- operators would give wrong types. Each type defines its own operators.

extension Tagged where RawValue: AdditiveArithmetic {
    /// The zero value for this tagged type.
    @inlinable
    public static var zero: Self {
        Self(.zero)
    }
}


// MARK: - Negation

extension Tagged where RawValue: SignedNumeric {
    /// Returns the negation of this value.
    @inlinable
    public static prefix func - (value: Self) -> Self {
        Self(-value._rawValue)
    }
}

// MARK: - Absolute Value, Min, Max

/// Returns the absolute value of a tagged value.
@inlinable
public func abs<Tag, T: SignedNumeric & Comparable>(_ x: Tagged<Tag, T>) -> Tagged<Tag, T> {
    Tagged(abs(x._rawValue))
}

/// Returns the minimum of two tagged values.
@inlinable
public func min<Tag, T: Comparable>(_ x: Tagged<Tag, T>, _ y: Tagged<Tag, T>) -> Tagged<Tag, T> {
    x._rawValue <= y._rawValue ? x : y
}

/// Returns the maximum of two tagged values.
@inlinable
public func max<Tag, T: Comparable>(_ x: Tagged<Tag, T>, _ y: Tagged<Tag, T>) -> Tagged<Tag, T> {
    x._rawValue >= y._rawValue ? x : y
}


// NOTE: Blanket scaling operators (Tagged * Int, Tagged / Int) were removed.
// In affine geometry, only Displacements and Magnitudes can be scaled - not Coordinates.
// See below for mathematically correct per-type scaling operators.

// MARK: - Angle Scaling by Integer

/// Multiplies a radian angle by an integer.
@inlinable
public func * <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Tagged<Angle.Radian, Scalar>, rhs: I
) -> Tagged<Angle.Radian, Scalar> {
    Tagged(lhs._rawValue * Scalar(rhs))
}

/// Multiplies an integer by a radian angle.
@inlinable
public func * <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: I, rhs: Tagged<Angle.Radian, Scalar>
) -> Tagged<Angle.Radian, Scalar> {
    Tagged(Scalar(lhs) * rhs._rawValue)
}

/// Divides a radian angle by an integer.
@inlinable
public func / <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Tagged<Angle.Radian, Scalar>, rhs: I
) -> Tagged<Angle.Radian, Scalar> {
    Tagged(lhs._rawValue / Scalar(rhs))
}

/// Multiplies a degree angle by an integer.
@inlinable
public func * <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Tagged<Angle.Degree, Scalar>, rhs: I
) -> Tagged<Angle.Degree, Scalar> {
    Tagged(lhs._rawValue * Scalar(rhs))
}

/// Multiplies an integer by a degree angle.
@inlinable
public func * <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: I, rhs: Tagged<Angle.Degree, Scalar>
) -> Tagged<Angle.Degree, Scalar> {
    Tagged(Scalar(lhs) * rhs._rawValue)
}

/// Divides a degree angle by an integer.
@inlinable
public func / <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Tagged<Angle.Degree, Scalar>, rhs: I
) -> Tagged<Angle.Degree, Scalar> {
    Tagged(lhs._rawValue / Scalar(rhs))
}

// MARK: - Angle Scaling by Scalar

/// Multiplies a radian angle by a scalar.
@inlinable
public func * <Scalar: FloatingPoint>(
    lhs: Tagged<Angle.Radian, Scalar>, rhs: Scalar
) -> Tagged<Angle.Radian, Scalar> {
    Tagged(lhs._rawValue * rhs)
}

/// Multiplies a scalar by a radian angle.
@inlinable
public func * <Scalar: FloatingPoint>(
    lhs: Scalar, rhs: Tagged<Angle.Radian, Scalar>
) -> Tagged<Angle.Radian, Scalar> {
    Tagged(lhs * rhs._rawValue)
}

/// Divides a radian angle by a scalar.
@inlinable
public func / <Scalar: FloatingPoint>(
    lhs: Tagged<Angle.Radian, Scalar>, rhs: Scalar
) -> Tagged<Angle.Radian, Scalar> {
    Tagged(lhs._rawValue / rhs)
}

/// Multiplies a degree angle by a scalar.
@inlinable
public func * <Scalar: FloatingPoint>(
    lhs: Tagged<Angle.Degree, Scalar>, rhs: Scalar
) -> Tagged<Angle.Degree, Scalar> {
    Tagged(lhs._rawValue * rhs)
}

/// Multiplies a scalar by a degree angle.
@inlinable
public func * <Scalar: FloatingPoint>(
    lhs: Scalar, rhs: Tagged<Angle.Degree, Scalar>
) -> Tagged<Angle.Degree, Scalar> {
    Tagged(lhs * rhs._rawValue)
}

/// Divides a degree angle by a scalar.
@inlinable
public func / <Scalar: FloatingPoint>(
    lhs: Tagged<Angle.Degree, Scalar>, rhs: Scalar
) -> Tagged<Angle.Degree, Scalar> {
    Tagged(lhs._rawValue / rhs)
}

// MARK: - Displacement Same-Type Arithmetic

/// Adds two X-displacements.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two X-displacements.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Adds two Y-displacements.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two Y-displacements.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Adds two Z-displacements.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two Z-displacements.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

// MARK: - Magnitude Same-Type Arithmetic

/// Adds two magnitudes.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Magnitude<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two magnitudes.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Magnitude<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Add and assign magnitudes.
@inlinable
public func += <Space, Scalar: AdditiveArithmetic>(
    lhs: inout Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) {
    lhs = lhs + rhs
}

/// Subtract and assign magnitudes.
@inlinable
public func -= <Space, Scalar: AdditiveArithmetic>(
    lhs: inout Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) {
    lhs = lhs - rhs
}

// MARK: - Angle Same-Type Arithmetic

/// Adds two radian angles.
@inlinable
public func + <Scalar: AdditiveArithmetic>(
    lhs: Tagged<Angle.Radian, Scalar>,
    rhs: Tagged<Angle.Radian, Scalar>
) -> Tagged<Angle.Radian, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two radian angles.
@inlinable
public func - <Scalar: AdditiveArithmetic>(
    lhs: Tagged<Angle.Radian, Scalar>,
    rhs: Tagged<Angle.Radian, Scalar>
) -> Tagged<Angle.Radian, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Adds two degree angles.
@inlinable
public func + <Scalar: AdditiveArithmetic>(
    lhs: Tagged<Angle.Degree, Scalar>,
    rhs: Tagged<Angle.Degree, Scalar>
) -> Tagged<Angle.Degree, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two degree angles.
@inlinable
public func - <Scalar: AdditiveArithmetic>(
    lhs: Tagged<Angle.Degree, Scalar>,
    rhs: Tagged<Angle.Degree, Scalar>
) -> Tagged<Angle.Degree, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

// MARK: - Displacement Multiplication → Area

// Displacement products return typed Area (Measure<2>).
// Same-axis: Dx × Dx = Area (length squared)
// Cross-axis: Dx × Dy = Area (length × length)

/// Multiplies X-displacement by X-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Y-displacement by Y-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Z-displacement by Z-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies X-displacement by Y-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Y-displacement by X-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies X-displacement by Z-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Z-displacement by X-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Y-displacement by Z-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Z-displacement by Y-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

// MARK: - Measure Multiplication

/// Multiplies two lengths (Measure<1>), returning area (Measure<2>).
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Measure<1, Space>, Scalar>,
    rhs: Tagged<Measure<1, Space>, Scalar>
) -> Tagged<Measure<2, Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies length by area, returning volume (Measure<3>).
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Measure<1, Space>, Scalar>,
    rhs: Tagged<Measure<2, Space>, Scalar>
) -> Tagged<Measure<3, Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies area by length, returning volume (Measure<3>).
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Tagged<Measure<2, Space>, Scalar>,
    rhs: Tagged<Measure<1, Space>, Scalar>
) -> Tagged<Measure<3, Space>, Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

// MARK: - Area Arithmetic

/// Adds two areas.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Area<Space>, Scalar>,
    rhs: Tagged<Area<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two areas.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Area<Space>, Scalar>,
    rhs: Tagged<Area<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Divides two areas, returning a dimensionless ratio.
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Tagged<Area<Space>, Scalar>,
    rhs: Tagged<Area<Space>, Scalar>
) -> Scalar {
    lhs._rawValue / rhs._rawValue
}

// MARK: - Mixed Coordinate/Displacement Arithmetic

// Affine geometry: Point + Vector = Point, Point - Point = Vector, Point - Vector = Point
// These are free functions generic over Space to work with any coordinate system.

// MARK: X Axis

/// Adds a displacement to an X coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a displacement to an X coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts two X coordinates, returning a displacement.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Coordinate.X<Space>, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts two X coordinates with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Coordinate.X<Space>, Scalar>
) -> Tagged<Displacement.X<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Subtracts a displacement from an X coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a displacement from an X coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Displacement.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds an X coordinate to a displacement, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Tagged<Coordinate.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds an X coordinate to a displacement with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Tagged<Coordinate.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts an X coordinate from a displacement, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Tagged<Coordinate.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts an X coordinate from a displacement with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.X<Space>, Scalar>,
    rhs: Tagged<Coordinate.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

// MARK: Y Axis

/// Adds a displacement to a Y coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a displacement to a Y coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts two Y coordinates, returning a displacement.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Coordinate.Y<Space>, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts two Y coordinates with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Coordinate.Y<Space>, Scalar>
) -> Tagged<Displacement.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Subtracts a displacement from a Y coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a displacement from a Y coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Displacement.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds a Y coordinate to a displacement, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Tagged<Coordinate.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a Y coordinate to a displacement with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Tagged<Coordinate.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts a Y coordinate from a displacement, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Tagged<Coordinate.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a Y coordinate from a displacement with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.Y<Space>, Scalar>,
    rhs: Tagged<Coordinate.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

// MARK: Z Axis

/// Adds a displacement to a Z coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a displacement to a Z coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts two Z coordinates, returning a displacement.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Coordinate.Z<Space>, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts two Z coordinates with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Coordinate.Z<Space>, Scalar>
) -> Tagged<Displacement.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Subtracts a displacement from a Z coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a displacement from a Z coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Displacement.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds a Z coordinate to a displacement, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Tagged<Coordinate.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a Z coordinate to a displacement with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Tagged<Coordinate.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts a Z coordinate from a displacement, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Tagged<Coordinate.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a Z coordinate from a displacement with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Displacement.Z<Space>, Scalar>,
    rhs: Tagged<Coordinate.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

// MARK: - Magnitude/Coordinate Arithmetic

// Magnitude (non-directional distance) can be added/subtracted from coordinates.
// This enables `center.x - radius` patterns in geometry code.
// The magnitude is interpreted as distance along the axis of the coordinate.

/// Adds a magnitude to an X coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a magnitude to an X coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts a magnitude from an X coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a magnitude from an X coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.X<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds an X coordinate to a magnitude, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Coordinate.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds an X coordinate to a magnitude with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Coordinate.X<Space>, Scalar>
) -> Tagged<Coordinate.X<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Adds a magnitude to a Y coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a magnitude to a Y coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts a magnitude from a Y coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a magnitude from a Y coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Y<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds a Y coordinate to a magnitude, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Coordinate.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a Y coordinate to a magnitude with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Coordinate.Y<Space>, Scalar>
) -> Tagged<Coordinate.Y<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Adds a magnitude to a Z coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a magnitude to a Z coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts a magnitude from a Z coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a magnitude from a Z coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Coordinate.Z<Space>, Scalar>,
    rhs: Tagged<Magnitude<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds a Z coordinate to a magnitude, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Coordinate.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a Z coordinate to a magnitude with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Magnitude<Space>, Scalar>,
    rhs: Tagged<Coordinate.Z<Space>, Scalar>
) -> Tagged<Coordinate.Z<Space>, Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

// MARK: - Strideable

extension Tagged: Strideable where RawValue: Strideable {
    public typealias Stride = RawValue.Stride

    @inlinable
    public func distance(to other: Self) -> Stride {
        _rawValue.distance(to: other._rawValue)
    }

    @inlinable
    public func advanced(by n: Stride) -> Self {
        Self(_rawValue.advanced(by: n))
    }
}

extension Tagged where RawValue: BinaryFloatingPoint {
    public init<I: BinaryInteger>(_ value: I) {
        self.init(RawValue(value))
    }
}
