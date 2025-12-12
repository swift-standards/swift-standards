//
//  Tagged+Quantized.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 12/12/2025.
//

// MARK: - Tagged Quantization

extension Tagged where RawValue: BinaryFloatingPoint {
    /// Creates a tagged value quantized to the given quantum.
    @inlinable
    public init(quantized rawValue: RawValue, quantum: RawValue) {
        self.rawValue = (rawValue / quantum).rounded() * quantum
    }
}

// MARK: - Quantized Coordinate/Displacement Arithmetic

// These operators are free functions with Space: Quantized constraint.
// Swift prefers more specific overloads, so these will be selected over
// the @_disfavoredOverload versions in Tagged.swift when Space: Quantized.

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

/// Adds two X displacements in a quantized space.
@inlinable
public func + <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.X.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.X.Displacement<Space>, Scalar>
) -> Tagged<Index.X.Displacement<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue + rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts two X displacements in a quantized space.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.X.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.X.Displacement<Space>, Scalar>
) -> Tagged<Index.X.Displacement<Space>, Scalar> {
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

/// Adds two Y displacements in a quantized space.
@inlinable
public func + <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Y.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.Y.Displacement<Space>, Scalar>
) -> Tagged<Index.Y.Displacement<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue + rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts two Y displacements in a quantized space.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Y.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.Y.Displacement<Space>, Scalar>
) -> Tagged<Index.Y.Displacement<Space>, Scalar> {
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

/// Adds two Z displacements in a quantized space.
@inlinable
public func + <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Z.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.Z.Displacement<Space>, Scalar>
) -> Tagged<Index.Z.Displacement<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue + rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}

/// Subtracts two Z displacements in a quantized space.
@inlinable
public func - <Space: Quantized, Scalar: BinaryFloatingPoint>(
    lhs: Tagged<Index.Z.Displacement<Space>, Scalar>,
    rhs: Tagged<Index.Z.Displacement<Space>, Scalar>
) -> Tagged<Index.Z.Displacement<Space>, Scalar> {
    Tagged(quantized: lhs.rawValue - rhs.rawValue, quantum: Space.quantum(as: Scalar.self))
}
