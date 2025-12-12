//
//  File.swift
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

// These operators are defined as static extension methods on Tagged.
// Swift prefers static methods over free functions in overload resolution,
// so these will be selected when Space: Quantized.

// MARK: X Coordinate + X Displacement

extension Tagged where RawValue: BinaryFloatingPoint {
    /// Adds a displacement to an X coordinate in a quantized space.
    @inlinable
    public static func + <Space: Quantized>(
        lhs: Tagged<Index.X.Coordinate<Space>, RawValue>,
        rhs: Tagged<Index.X.Displacement<Space>, RawValue>
    ) -> Tagged<Index.X.Coordinate<Space>, RawValue> where Tag == Index.X.Coordinate<Space> {
        Tagged<Index.X.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue + rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts two X coordinates in a quantized space, returning a displacement.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.X.Coordinate<Space>, RawValue>,
        rhs: Tagged<Index.X.Coordinate<Space>, RawValue>
    ) -> Tagged<Index.X.Displacement<Space>, RawValue> where Tag == Index.X.Coordinate<Space> {
        Tagged<Index.X.Displacement<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts a displacement from an X coordinate in a quantized space.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.X.Coordinate<Space>, RawValue>,
        rhs: Tagged<Index.X.Displacement<Space>, RawValue>
    ) -> Tagged<Index.X.Coordinate<Space>, RawValue> where Tag == Index.X.Coordinate<Space> {
        Tagged<Index.X.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }
}

// MARK: X Displacement + X Coordinate

extension Tagged where RawValue: BinaryFloatingPoint {
    /// Adds an X coordinate to a displacement in a quantized space (commutative).
    @inlinable
    public static func + <Space: Quantized>(
        lhs: Tagged<Index.X.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.X.Coordinate<Space>, RawValue>
    ) -> Tagged<Index.X.Coordinate<Space>, RawValue> where Tag == Index.X.Displacement<Space> {
        Tagged<Index.X.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue + rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts an X coordinate from a displacement in a quantized space.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.X.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.X.Coordinate<Space>, RawValue>
    ) -> Tagged<Index.X.Coordinate<Space>, RawValue> where Tag == Index.X.Displacement<Space> {
        Tagged<Index.X.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Adds two X displacements in a quantized space.
    @inlinable
    public static func + <Space: Quantized>(
        lhs: Tagged<Index.X.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.X.Displacement<Space>, RawValue>
    ) -> Tagged<Index.X.Displacement<Space>, RawValue> where Tag == Index.X.Displacement<Space> {
        Tagged<Index.X.Displacement<Space>, RawValue>(
            quantized: lhs.rawValue + rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts two X displacements in a quantized space.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.X.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.X.Displacement<Space>, RawValue>
    ) -> Tagged<Index.X.Displacement<Space>, RawValue> where Tag == Index.X.Displacement<Space> {
        Tagged<Index.X.Displacement<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }
}

// MARK: Y Coordinate + Y Displacement

extension Tagged where RawValue: BinaryFloatingPoint {
    /// Adds a displacement to a Y coordinate in a quantized space.
    @inlinable
    public static func + <Space: Quantized>(
        lhs: Tagged<Index.Y.Coordinate<Space>, RawValue>,
        rhs: Tagged<Index.Y.Displacement<Space>, RawValue>
    ) -> Tagged<Index.Y.Coordinate<Space>, RawValue> where Tag == Index.Y.Coordinate<Space> {
        Tagged<Index.Y.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue + rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts two Y coordinates in a quantized space, returning a displacement.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.Y.Coordinate<Space>, RawValue>,
        rhs: Tagged<Index.Y.Coordinate<Space>, RawValue>
    ) -> Tagged<Index.Y.Displacement<Space>, RawValue> where Tag == Index.Y.Coordinate<Space> {
        Tagged<Index.Y.Displacement<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts a displacement from a Y coordinate in a quantized space.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.Y.Coordinate<Space>, RawValue>,
        rhs: Tagged<Index.Y.Displacement<Space>, RawValue>
    ) -> Tagged<Index.Y.Coordinate<Space>, RawValue> where Tag == Index.Y.Coordinate<Space> {
        Tagged<Index.Y.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }
}

// MARK: Y Displacement + Y Coordinate

extension Tagged where RawValue: BinaryFloatingPoint {
    /// Adds a Y coordinate to a displacement in a quantized space (commutative).
    @inlinable
    public static func + <Space: Quantized>(
        lhs: Tagged<Index.Y.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.Y.Coordinate<Space>, RawValue>
    ) -> Tagged<Index.Y.Coordinate<Space>, RawValue> where Tag == Index.Y.Displacement<Space> {
        Tagged<Index.Y.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue + rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts a Y coordinate from a displacement in a quantized space.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.Y.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.Y.Coordinate<Space>, RawValue>
    ) -> Tagged<Index.Y.Coordinate<Space>, RawValue> where Tag == Index.Y.Displacement<Space> {
        Tagged<Index.Y.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Adds two Y displacements in a quantized space.
    @inlinable
    public static func + <Space: Quantized>(
        lhs: Tagged<Index.Y.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.Y.Displacement<Space>, RawValue>
    ) -> Tagged<Index.Y.Displacement<Space>, RawValue> where Tag == Index.Y.Displacement<Space> {
        Tagged<Index.Y.Displacement<Space>, RawValue>(
            quantized: lhs.rawValue + rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts two Y displacements in a quantized space.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.Y.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.Y.Displacement<Space>, RawValue>
    ) -> Tagged<Index.Y.Displacement<Space>, RawValue> where Tag == Index.Y.Displacement<Space> {
        Tagged<Index.Y.Displacement<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }
}

// MARK: Z Coordinate + Z Displacement

extension Tagged where RawValue: BinaryFloatingPoint {
    /// Adds a displacement to a Z coordinate in a quantized space.
    @inlinable
    public static func + <Space: Quantized>(
        lhs: Tagged<Index.Z.Coordinate<Space>, RawValue>,
        rhs: Tagged<Index.Z.Displacement<Space>, RawValue>
    ) -> Tagged<Index.Z.Coordinate<Space>, RawValue> where Tag == Index.Z.Coordinate<Space> {
        Tagged<Index.Z.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue + rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts two Z coordinates in a quantized space, returning a displacement.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.Z.Coordinate<Space>, RawValue>,
        rhs: Tagged<Index.Z.Coordinate<Space>, RawValue>
    ) -> Tagged<Index.Z.Displacement<Space>, RawValue> where Tag == Index.Z.Coordinate<Space> {
        Tagged<Index.Z.Displacement<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts a displacement from a Z coordinate in a quantized space.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.Z.Coordinate<Space>, RawValue>,
        rhs: Tagged<Index.Z.Displacement<Space>, RawValue>
    ) -> Tagged<Index.Z.Coordinate<Space>, RawValue> where Tag == Index.Z.Coordinate<Space> {
        Tagged<Index.Z.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }
}

// MARK: Z Displacement + Z Coordinate

extension Tagged where RawValue: BinaryFloatingPoint {
    /// Adds a Z coordinate to a displacement in a quantized space (commutative).
    @inlinable
    public static func + <Space: Quantized>(
        lhs: Tagged<Index.Z.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.Z.Coordinate<Space>, RawValue>
    ) -> Tagged<Index.Z.Coordinate<Space>, RawValue> where Tag == Index.Z.Displacement<Space> {
        Tagged<Index.Z.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue + rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts a Z coordinate from a displacement in a quantized space.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.Z.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.Z.Coordinate<Space>, RawValue>
    ) -> Tagged<Index.Z.Coordinate<Space>, RawValue> where Tag == Index.Z.Displacement<Space> {
        Tagged<Index.Z.Coordinate<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Adds two Z displacements in a quantized space.
    @inlinable
    public static func + <Space: Quantized>(
        lhs: Tagged<Index.Z.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.Z.Displacement<Space>, RawValue>
    ) -> Tagged<Index.Z.Displacement<Space>, RawValue> where Tag == Index.Z.Displacement<Space> {
        Tagged<Index.Z.Displacement<Space>, RawValue>(
            quantized: lhs.rawValue + rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }

    /// Subtracts two Z displacements in a quantized space.
    @inlinable
    public static func - <Space: Quantized>(
        lhs: Tagged<Index.Z.Displacement<Space>, RawValue>,
        rhs: Tagged<Index.Z.Displacement<Space>, RawValue>
    ) -> Tagged<Index.Z.Displacement<Space>, RawValue> where Tag == Index.Z.Displacement<Space> {
        Tagged<Index.Z.Displacement<Space>, RawValue>(
            quantized: lhs.rawValue - rhs.rawValue,
            quantum: Space.quantum(as: RawValue.self)
        )
    }
}
