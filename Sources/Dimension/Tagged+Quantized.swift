//
//  Tagged+Quantized.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 12/12/2025.
//

// MARK: - Tagged Quantization

extension Tagged where RawValue: BinaryFloatingPoint {
    /// Creates a tagged value quantized to the given quantum.
    ///
    /// Uses multiplication by reciprocal to avoid floating-point errors
    /// with quantum values that can't be represented exactly (e.g., 0.01).
    @inlinable
    public init(quantized rawValue: RawValue, quantum: RawValue) {
        let scale = 1.0 / Double(quantum)
        let scaledValue = Double(rawValue) * scale
        let rounded = scaledValue.rounded()
        self.rawValue = RawValue(rounded / scale)
    }
}

// MARK: - Quantized Displacement Arithmetic (Static Methods)

// These MUST be static methods to win over AdditiveArithmetic's static methods.
// Free functions lose to static methods regardless of constraints.

extension Tagged where Tag: QuantizedDisplacementTag, RawValue: BinaryFloatingPoint {
    /// Adds two displacements in a quantized space.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(quantized: lhs.rawValue + rhs.rawValue, quantum: Tag.Space.quantum(as: RawValue.self))
    }

    /// Subtracts two displacements in a quantized space.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(quantized: lhs.rawValue - rhs.rawValue, quantum: Tag.Space.quantum(as: RawValue.self))
    }
}

// MARK: - Quantized Coordinate/Displacement Arithmetic (Free Functions)

// These free functions work because they have DIFFERENT return types or operand types
// than AdditiveArithmetic, so there's no competition.

// MARK: X Axis

/// Adds a displacement to an X coordinate in a quantized space.
@inlinable
public func + <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.X.Coordinate<Space>, Scalar>,
    rhs: Tagged<Index.X.Displacement<Space>, Scalar>
) -> Tagged<Index.X.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue + rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts two X coordinates in a quantized space, returning a displacement.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.X.Coordinate<Space>, Scalar>,
    rhs: Tagged<Index.X.Coordinate<Space>, Scalar>
) -> Tagged<Index.X.Displacement<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts a displacement from an X coordinate in a quantized space.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.X.Coordinate<Space>, Scalar>,
    rhs: Tagged<Index.X.Displacement<Space>, Scalar>
) -> Tagged<Index.X.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Adds an X coordinate to a displacement in a quantized space (commutative).
@inlinable
public func + <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.X.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.X.Coordinate<Space>, Scalar>
) -> Tagged<Index.X.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue + rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts an X coordinate from a displacement in a quantized space.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.X.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.X.Coordinate<Space>, Scalar>
) -> Tagged<Index.X.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

// MARK: Y Axis

/// Adds a displacement to a Y coordinate in a quantized space.
@inlinable
public func + <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Y.Coordinate<Space>, Scalar>,
    rhs: Tagged<Index.Y.Displacement<Space>, Scalar>
) -> Tagged<Index.Y.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue + rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts two Y coordinates in a quantized space, returning a displacement.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Y.Coordinate<Space>, Scalar>,
    rhs: Tagged<Index.Y.Coordinate<Space>, Scalar>
) -> Tagged<Index.Y.Displacement<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts a displacement from a Y coordinate in a quantized space.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Y.Coordinate<Space>, Scalar>,
    rhs: Tagged<Index.Y.Displacement<Space>, Scalar>
) -> Tagged<Index.Y.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Adds a Y coordinate to a displacement in a quantized space (commutative).
@inlinable
public func + <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Y.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.Y.Coordinate<Space>, Scalar>
) -> Tagged<Index.Y.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue + rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts a Y coordinate from a displacement in a quantized space.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Y.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.Y.Coordinate<Space>, Scalar>
) -> Tagged<Index.Y.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

// MARK: Z Axis

/// Adds a displacement to a Z coordinate in a quantized space.
@inlinable
public func + <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Z.Coordinate<Space>, Scalar>,
    rhs: Tagged<Index.Z.Displacement<Space>, Scalar>
) -> Tagged<Index.Z.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue + rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts two Z coordinates in a quantized space, returning a displacement.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Z.Coordinate<Space>, Scalar>,
    rhs: Tagged<Index.Z.Coordinate<Space>, Scalar>
) -> Tagged<Index.Z.Displacement<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts a displacement from a Z coordinate in a quantized space.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Z.Coordinate<Space>, Scalar>,
    rhs: Tagged<Index.Z.Displacement<Space>, Scalar>
) -> Tagged<Index.Z.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Adds a Z coordinate to a displacement in a quantized space (commutative).
@inlinable
public func + <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Z.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.Z.Coordinate<Space>, Scalar>
) -> Tagged<Index.Z.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue + rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts a Z coordinate from a displacement in a quantized space.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Z.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.Z.Coordinate<Space>, Scalar>
) -> Tagged<Index.Z.Coordinate<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}
