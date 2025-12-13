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
    lhs: Angle.Radian.Value<Scalar>, rhs: I
) -> Angle.Radian.Value<Scalar> {
    Tagged(lhs._rawValue * Scalar(rhs))
}

/// Multiplies an integer by a radian angle.
@inlinable
public func * <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: I, rhs: Angle.Radian.Value<Scalar>
) -> Angle.Radian.Value<Scalar> {
    Tagged(Scalar(lhs) * rhs._rawValue)
}

/// Divides a radian angle by an integer.
@inlinable
public func / <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Angle.Radian.Value<Scalar>, rhs: I
) -> Angle.Radian.Value<Scalar> {
    Tagged(lhs._rawValue / Scalar(rhs))
}

/// Multiplies a degree angle by an integer.
@inlinable
public func * <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Angle.Degree.Value<Scalar>, rhs: I
) -> Angle.Degree.Value<Scalar> {
    Tagged(lhs._rawValue * Scalar(rhs))
}

/// Multiplies an integer by a degree angle.
@inlinable
public func * <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: I, rhs: Angle.Degree.Value<Scalar>
) -> Angle.Degree.Value<Scalar> {
    Tagged(Scalar(lhs) * rhs._rawValue)
}

/// Divides a degree angle by an integer.
@inlinable
public func / <Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Angle.Degree.Value<Scalar>, rhs: I
) -> Angle.Degree.Value<Scalar> {
    Tagged(lhs._rawValue / Scalar(rhs))
}

// MARK: - Angle Scaling by Scalar

/// Multiplies a radian angle by a scalar.
@inlinable
public func * <Scalar: FloatingPoint>(
    lhs: Angle.Radian.Value<Scalar>, rhs: Scalar
) -> Angle.Radian.Value<Scalar> {
    Tagged(lhs._rawValue * rhs)
}

/// Multiplies a scalar by a radian angle.
@inlinable
public func * <Scalar: FloatingPoint>(
    lhs: Scalar, rhs: Angle.Radian.Value<Scalar>
) -> Angle.Radian.Value<Scalar> {
    Tagged(lhs * rhs._rawValue)
}

/// Divides a radian angle by a scalar.
@inlinable
public func / <Scalar: FloatingPoint>(
    lhs: Angle.Radian.Value<Scalar>, rhs: Scalar
) -> Angle.Radian.Value<Scalar> {
    Tagged(lhs._rawValue / rhs)
}

/// Multiplies a degree angle by a scalar.
@inlinable
public func * <Scalar: FloatingPoint>(
    lhs: Angle.Degree.Value<Scalar>, rhs: Scalar
) -> Angle.Degree.Value<Scalar> {
    Tagged(lhs._rawValue * rhs)
}

/// Multiplies a scalar by a degree angle.
@inlinable
public func * <Scalar: FloatingPoint>(
    lhs: Scalar, rhs: Angle.Degree.Value<Scalar>
) -> Angle.Degree.Value<Scalar> {
    Tagged(lhs * rhs._rawValue)
}

/// Divides a degree angle by a scalar.
@inlinable
public func / <Scalar: FloatingPoint>(
    lhs: Angle.Degree.Value<Scalar>, rhs: Scalar
) -> Angle.Degree.Value<Scalar> {
    Tagged(lhs._rawValue / rhs)
}

// MARK: - Displacement Same-Type Arithmetic

/// Adds two X-displacements.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two X-displacements.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Adds two Y-displacements.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two Y-displacements.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Adds two Z-displacements.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two Z-displacements.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

// MARK: - Magnitude Same-Type Arithmetic

/// Adds two magnitudes.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Magnitude<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two magnitudes.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Magnitude<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Add and assign magnitudes.
@inlinable
public func += <Space, Scalar: AdditiveArithmetic>(
    lhs: inout Magnitude<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) {
    lhs = lhs + rhs
}

/// Subtract and assign magnitudes.
@inlinable
public func -= <Space, Scalar: AdditiveArithmetic>(
    lhs: inout Magnitude<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) {
    lhs = lhs - rhs
}

// MARK: - Angle Same-Type Arithmetic

/// Adds two radian angles.
@inlinable
public func + <Scalar: AdditiveArithmetic>(
    lhs: Angle.Radian.Value<Scalar>,
    rhs: Angle.Radian.Value<Scalar>
) -> Angle.Radian.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two radian angles.
@inlinable
public func - <Scalar: AdditiveArithmetic>(
    lhs: Angle.Radian.Value<Scalar>,
    rhs: Angle.Radian.Value<Scalar>
) -> Angle.Radian.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Adds two degree angles.
@inlinable
public func + <Scalar: AdditiveArithmetic>(
    lhs: Angle.Degree.Value<Scalar>,
    rhs: Angle.Degree.Value<Scalar>
) -> Angle.Degree.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two degree angles.
@inlinable
public func - <Scalar: AdditiveArithmetic>(
    lhs: Angle.Degree.Value<Scalar>,
    rhs: Angle.Degree.Value<Scalar>
) -> Angle.Degree.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

// MARK: - Displacement Multiplication → Area

// Displacement products return typed Area (Measure<2>).
// Same-axis: Dx × Dx = Area (length squared)
// Cross-axis: Dx × Dy = Area (length × length)

/// Multiplies X-displacement by X-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Y-displacement by Y-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Z-displacement by Z-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies X-displacement by Y-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Y-displacement by X-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies X-displacement by Z-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Z-displacement by X-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Y-displacement by Z-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies Z-displacement by Y-displacement, returning area.
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

// MARK: - Measure Multiplication

/// Multiplies two lengths (Measure<1>), returning area (Measure<2>).
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Measure<1, Space>.Value<Scalar>,
    rhs: Measure<1, Space>.Value<Scalar>
) -> Measure<2, Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies length by area, returning volume (Measure<3>).
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Measure<1, Space>.Value<Scalar>,
    rhs: Measure<2, Space>.Value<Scalar>
) -> Measure<3, Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

/// Multiplies area by length, returning volume (Measure<3>).
@inlinable
public func * <Space, Scalar: Numeric>(
    lhs: Measure<2, Space>.Value<Scalar>,
    rhs: Measure<1, Space>.Value<Scalar>
) -> Measure<3, Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs._rawValue)
}

// MARK: - Area Arithmetic

/// Adds two areas.
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Area<Space>.Value<Scalar>,
    rhs: Area<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Subtracts two areas.
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Area<Space>.Value<Scalar>,
    rhs: Area<Space>.Value<Scalar>
) -> Area<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Divides two areas, returning a dimensionless ratio.
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Area<Space>.Value<Scalar>,
    rhs: Area<Space>.Value<Scalar>
) -> Scalar {
    lhs._rawValue / rhs._rawValue
}

// MARK: - Measure Scaling (Magnitude, Area, Volume)

/// Multiplies a measure by a scalar.
@inlinable
public func * <let N: Int, Space, Scalar: FloatingPoint>(
    lhs: Measure<N, Space>.Value<Scalar>,
    rhs: Scalar
) -> Measure<N, Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs)
}

/// Multiplies a scalar by a measure.
@inlinable
public func * <let N: Int, Space, Scalar: FloatingPoint>(
    lhs: Scalar,
    rhs: Measure<N, Space>.Value<Scalar>
) -> Measure<N, Space>.Value<Scalar> {
    Tagged(lhs * rhs._rawValue)
}

/// Divides a measure by a scalar.
@inlinable
public func / <let N: Int, Space, Scalar: FloatingPoint>(
    lhs: Measure<N, Space>.Value<Scalar>,
    rhs: Scalar
) -> Measure<N, Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs)
}

/// Multiplies a measure by an integer.
@inlinable
public func * <let N: Int, Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Measure<N, Space>.Value<Scalar>,
    rhs: I
) -> Measure<N, Space>.Value<Scalar> {
    Tagged(lhs._rawValue * Scalar(rhs))
}

/// Multiplies an integer by a measure.
@inlinable
public func * <let N: Int, Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: I,
    rhs: Measure<N, Space>.Value<Scalar>
) -> Measure<N, Space>.Value<Scalar> {
    Tagged(Scalar(lhs) * rhs._rawValue)
}

/// Divides a measure by an integer.
@inlinable
public func / <let N: Int, Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Measure<N, Space>.Value<Scalar>,
    rhs: I
) -> Measure<N, Space>.Value<Scalar> {
    Tagged(lhs._rawValue / Scalar(rhs))
}

// MARK: - Area / Magnitude = Magnitude (L² / L = L)

/// Divides area by magnitude, returning magnitude.
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Area<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Magnitude<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs._rawValue)
}

/// Divides area by area, returning a dimensionless scale factor.
/// Area / Area = dimensionless ratio (L² / L² = 1)
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Area<Space>.Value<Scalar>,
    rhs: Area<Space>.Value<Scalar>
) -> Scale<1, Scalar> {
    Scale(lhs._rawValue / rhs._rawValue)
}

// MARK: - Displacement Scaling

/// Multiplies X-displacement by a scalar.
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Scalar
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs)
}

/// Multiplies a scalar by X-displacement.
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scalar,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs * rhs._rawValue)
}

/// Divides X-displacement by a scalar.
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Scalar
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs)
}

/// Divides two X-displacements, returning a dimensionless ratio.
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Scalar {
    lhs._rawValue / rhs._rawValue
}

/// Multiplies Y-displacement by a scalar.
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Scalar
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs)
}

/// Multiplies a scalar by Y-displacement.
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scalar,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs * rhs._rawValue)
}

/// Divides Y-displacement by a scalar.
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Scalar
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs)
}

/// Divides two Y-displacements, returning a dimensionless ratio.
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Scalar {
    lhs._rawValue / rhs._rawValue
}

/// Multiplies Z-displacement by a scalar.
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Scalar
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs)
}

/// Multiplies a scalar by Z-displacement.
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scalar,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs * rhs._rawValue)
}

/// Divides Z-displacement by a scalar.
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Scalar
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs)
}

/// Divides two Z-displacements, returning a dimensionless ratio.
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Scalar {
    lhs._rawValue / rhs._rawValue
}

// MARK: - Displacement Scaling by Integer

/// Multiplies X-displacement by an integer.
@inlinable
public func * <Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: I
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * Scalar(rhs))
}

/// Multiplies an integer by X-displacement.
@inlinable
public func * <Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: I,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(Scalar(lhs) * rhs._rawValue)
}

/// Divides X-displacement by an integer.
@inlinable
public func / <Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: I
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / Scalar(rhs))
}

/// Multiplies Y-displacement by an integer.
@inlinable
public func * <Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: I
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * Scalar(rhs))
}

/// Multiplies an integer by Y-displacement.
@inlinable
public func * <Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: I,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(Scalar(lhs) * rhs._rawValue)
}

/// Divides Y-displacement by an integer.
@inlinable
public func / <Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: I
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / Scalar(rhs))
}

/// Multiplies Z-displacement by an integer.
@inlinable
public func * <Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: I
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * Scalar(rhs))
}

/// Multiplies an integer by Z-displacement.
@inlinable
public func * <Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: I,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(Scalar(lhs) * rhs._rawValue)
}

/// Divides Z-displacement by an integer.
@inlinable
public func / <Space, Scalar: FloatingPoint, I: BinaryInteger>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: I
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / Scalar(rhs))
}

// MARK: - Mixed Coordinate/Displacement Arithmetic

// Affine geometry: Point + Vector = Point, Point - Point = Vector, Point - Vector = Point
// These are free functions generic over Space to work with any coordinate system.

// MARK: X Axis

/// Adds a displacement to an X coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a displacement to an X coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts two X coordinates, returning a displacement.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Coordinate.X<Space>.Value<Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts two X coordinates with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Coordinate.X<Space>.Value<Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Subtracts a displacement from an X coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a displacement from an X coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds an X coordinate to a displacement, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Coordinate.X<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds an X coordinate to a displacement with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Coordinate.X<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

// MARK: Y Axis

/// Adds a displacement to a Y coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a displacement to a Y coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts two Y coordinates, returning a displacement.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Coordinate.Y<Space>.Value<Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts two Y coordinates with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Coordinate.Y<Space>.Value<Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Subtracts a displacement from a Y coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a displacement from a Y coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds a Y coordinate to a displacement, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Coordinate.Y<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a Y coordinate to a displacement with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Coordinate.Y<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

// MARK: Z Axis

/// Adds a displacement to a Z coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a displacement to a Z coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts two Z coordinates, returning a displacement.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Coordinate.Z<Space>.Value<Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts two Z coordinates with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Coordinate.Z<Space>.Value<Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Subtracts a displacement from a Z coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a displacement from a Z coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds a Z coordinate to a displacement, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Coordinate.Z<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a Z coordinate to a displacement with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Coordinate.Z<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

// MARK: - Magnitude/Coordinate Arithmetic

// Magnitude (non-directional distance) can be added/subtracted from coordinates.
// This enables `center.x - radius` patterns in geometry code.
// The magnitude is interpreted as distance along the axis of the coordinate.

/// Adds a magnitude to an X coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a magnitude to an X coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts a magnitude from an X coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a magnitude from an X coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.X<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds an X coordinate to a magnitude, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Coordinate.X<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds an X coordinate to a magnitude with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Coordinate.X<Space>.Value<Scalar>
) -> Coordinate.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Adds a magnitude to a Y coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a magnitude to a Y coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts a magnitude from a Y coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a magnitude from a Y coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Y<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds a Y coordinate to a magnitude, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Coordinate.Y<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a Y coordinate to a magnitude with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Coordinate.Y<Space>.Value<Scalar>
) -> Coordinate.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Adds a magnitude to a Z coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a magnitude to a Z coordinate with quantization (for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}

/// Subtracts a magnitude from a Z coordinate, returning a coordinate.
@_disfavoredOverload
@inlinable
public func - <Space, Scalar: AdditiveArithmetic>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue - rhs._rawValue)
}

/// Subtracts a magnitude from a Z coordinate with quantization (for floating-point types).
@inlinable
public func - <Space, Scalar: BinaryFloatingPoint>(
    lhs: Coordinate.Z<Space>.Value<Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue - rhs._rawValue, in: Space.self)
}

/// Adds a Z coordinate to a magnitude, returning a coordinate (commutative).
@_disfavoredOverload
@inlinable
public func + <Space, Scalar: AdditiveArithmetic>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Coordinate.Z<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue + rhs._rawValue)
}

/// Adds a Z coordinate to a magnitude with quantization (commutative, for floating-point types).
@inlinable
public func + <Space, Scalar: BinaryFloatingPoint>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Coordinate.Z<Space>.Value<Scalar>
) -> Coordinate.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue + rhs._rawValue, in: Space.self)
}



// MARK: - Tagged × Scale<1> (Uniform Scaling)

// Displacement, Extent, and Magnitude can be scaled by dimensionless scale factors.
// Coordinates (positions) cannot be scaled - only vectors can.
// Using Scale<1, Scalar> makes the scaling operation explicit in the type system.

// MARK: Displacement.X × Scale

/// Scales an X displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales an X displacement by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales an X displacement by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales an X displacement by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Displacement.X<Space>.Value<Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides an X displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides an X displacement by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Displacement.X<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Displacement.Y × Scale

/// Scales a Y displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a Y displacement by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a Y displacement by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a Y displacement by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Displacement.Y<Space>.Value<Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a Y displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a Y displacement by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Displacement.Y<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Displacement.Z × Scale

/// Scales a Z displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a Z displacement by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a Z displacement by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a Z displacement by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Displacement.Z<Space>.Value<Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a Z displacement by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a Z displacement by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Displacement.Z<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Displacement.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Extent.X × Scale

/// Scales an X extent (width) by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Extent.X<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales an X extent (width) by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Extent.X<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales an X extent by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Extent.X<Space>.Value<Scalar>
) -> Extent.X<Space>.Value<Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales an X extent by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Extent.X<Space>.Value<Scalar>
) -> Extent.X<Space>.Value<Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides an X extent by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Extent.X<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.X<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides an X extent by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Extent.X<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.X<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Extent.Y × Scale

/// Scales a Y extent (height) by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Extent.Y<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a Y extent (height) by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Extent.Y<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a Y extent by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Extent.Y<Space>.Value<Scalar>
) -> Extent.Y<Space>.Value<Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a Y extent by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Extent.Y<Space>.Value<Scalar>
) -> Extent.Y<Space>.Value<Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a Y extent by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Extent.Y<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.Y<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a Y extent by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Extent.Y<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.Y<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Extent.Z × Scale

/// Scales a Z extent (depth) by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Extent.Z<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a Z extent (depth) by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Extent.Z<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a Z extent by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Extent.Z<Space>.Value<Scalar>
) -> Extent.Z<Space>.Value<Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a Z extent by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Extent.Z<Space>.Value<Scalar>
) -> Extent.Z<Space>.Value<Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a Z extent by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Extent.Z<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.Z<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a Z extent by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Extent.Z<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Extent.Z<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}

// MARK: Magnitude × Scale

/// Scales a magnitude by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Magnitude<Space>.Value<Scalar> {
    Tagged(lhs._rawValue * rhs.value)
}

/// Scales a magnitude by a uniform scale factor with quantization.
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Magnitude<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue * rhs.value, in: Space.self)
}

/// Scales a magnitude by a uniform scale factor (commutative).
@_disfavoredOverload
@inlinable
public func * <Space, Scalar: FloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Magnitude<Space>.Value<Scalar> {
    Tagged(lhs.value * rhs._rawValue)
}

/// Scales a magnitude by a uniform scale factor with quantization (commutative).
@inlinable
public func * <Space, Scalar: BinaryFloatingPoint>(
    lhs: Scale<1, Scalar>,
    rhs: Magnitude<Space>.Value<Scalar>
) -> Magnitude<Space>.Value<Scalar> {
    ._quantize(lhs.value * rhs._rawValue, in: Space.self)
}

/// Divides a magnitude by a uniform scale factor.
@_disfavoredOverload
@inlinable
public func / <Space, Scalar: FloatingPoint>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Magnitude<Space>.Value<Scalar> {
    Tagged(lhs._rawValue / rhs.value)
}

/// Divides a magnitude by a uniform scale factor with quantization.
@inlinable
public func / <Space, Scalar: BinaryFloatingPoint>(
    lhs: Magnitude<Space>.Value<Scalar>,
    rhs: Scale<1, Scalar>
) -> Magnitude<Space>.Value<Scalar> {
    ._quantize(lhs._rawValue / rhs.value, in: Space.self)
}
