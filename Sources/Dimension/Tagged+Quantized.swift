// Tagged+Quantized.swift
// Quantization support and affine arithmetic for Tagged types.

// MARK: - Canonical Quantization

extension Tagged where RawValue: BinaryFloatingPoint {
    /// Finalizes an arithmetic result, passing through unchanged.
    ///
    /// This overload is selected when Space does not conform to Quantized.
    /// Zero runtime cost: compiles to a direct initialization.
    @inlinable
    package static func _quantize<S>(_ value: RawValue, in space: S.Type) -> Self {
        Self(value)
    }

    /// Finalizes an arithmetic result with quantization to the grid.
    ///
    /// This overload is selected when Space conforms to Quantized.
    /// Produces canonical representation: same tick always yields identical bits.
    @inlinable
    package static func _quantize<S: Quantized>(_ value: RawValue, in space: S.Type) -> Self {
        let q = S.quantum(as: RawValue.self)
        let ticks = Int64((value / q).rounded())
        return Self(RawValue(ticks) * q)
    }
}

// MARK: - Tick Access

extension Tagged where Tag: Spatial, Tag.Space: Quantized, RawValue: BinaryFloatingPoint {
    /// The integer tick representing this quantized value.
    ///
    /// The tick is the canonical representation: `value ≈ tick × quantum`.
    /// Two values with equal ticks represent the same grid point.
    @inlinable
    public var ticks: Int64 {
        let q = Tag.Space.quantum(as: RawValue.self)
        return Int64((_rawValue / q).rounded())
    }

    /// Creates a tagged value from an integer tick count.
    ///
    /// - Parameter ticks: The grid point index
    @inlinable
    public init(ticks: Int64) {
        let q = Tag.Space.quantum(as: RawValue.self)
        self.init(RawValue(ticks) * q)
    }
}

// MARK: - Tick-Based Equality

extension Tagged where Tag: Spatial, Tag.Space: Quantized, RawValue: BinaryFloatingPoint {
    /// Compares two quantized values by their tick (grid point).
    ///
    /// This is the mathematically correct equality for quantized types:
    /// two values are equal iff they represent the same grid point,
    /// regardless of floating-point representation differences.
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.ticks == rhs.ticks
    }

    /// Compares two quantized values by their tick (grid point).
    @inlinable
    public static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.ticks != rhs.ticks
    }
}
