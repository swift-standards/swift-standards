// Axis.swift
// A coordinate axis in N-dimensional space.

/// A coordinate axis in N-dimensional space.
///
/// `Axis<N>` identifies one of exactly N basis vector directions in a coordinate system, independent of orientation. The type parameter provides compile-time dimension checking, preventing operations on incompatible spaces (e.g., cannot use `Axis<2>` in 3D context).
///
/// In linear algebra, axes are the basis vector directions indexed 0 through N-1. Use `primary`, `secondary`, `tertiary`, and `quaternary` for intuitive access to X, Y, Z, and W axes respectively.
///
/// ## Example
///
/// ```swift
/// let x: Axis<3> = .primary     // Axis 0 (X)
/// let y: Axis<3> = .secondary   // Axis 1 (Y)
/// let z: Axis<3> = .tertiary    // Axis 2 (Z)
///
/// // 2D perpendicular axis
/// let perp = Axis<2>.primary.perpendicular  // .secondary
///
/// // Iterate all axes
/// for axis in Axis<3>.allCases { print(axis.rawValue) }  // 0, 1, 2
/// ```
public struct Axis<let N: Int>: Sendable, Hashable {
    /// Zero-based index of this axis (0 to N-1).
    public let rawValue: Int

    /// Creates an axis from a raw index.
    ///
    /// - Returns: The axis, or `nil` if the index is out of bounds.
    @inlinable
    public init?(_ rawValue: Int) {
        guard rawValue >= 0 && rawValue < N else { return nil }
        self.rawValue = rawValue
    }

    /// Creates an axis from a raw value without bounds checking.
    @usableFromInline
    init(unchecked rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Codable

#if Codable
    extension Axis: Codable {
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(Int.self)
            guard let axis = Self(value) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "Axis index \(value) out of bounds for \(N)-dimensional space"
                    )
                )
            }
            self = axis
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }
#endif

// MARK: - 1D

extension Axis where N == 1 {
    /// First axis (index 0).
    @inlinable
    public static var primary: Self { Self(unchecked: 0) }
}

// MARK: - 2D

extension Axis where N == 2 {
    /// First axis (index 0, typically X/horizontal).
    @inlinable
    public static var primary: Self { Self(unchecked: 0) }

    /// Second axis (index 1, typically Y/vertical).
    @inlinable
    public static var secondary: Self { Self(unchecked: 1) }

    /// Returns the perpendicular axis of a 2D axis.
    ///
    /// In 2D, each axis has exactly one perpendicular: primary↔secondary.
    @inlinable
    public static func perpendicular(of axis: Self) -> Self {
        Self(unchecked: 1 - axis.rawValue)
    }

    /// Returns the perpendicular axis.
    ///
    /// In 2D, each axis has exactly one perpendicular: primary↔secondary.
    @inlinable
    public var perpendicular: Self {
        Self.perpendicular(of: self)
    }
}

// MARK: - 3D

extension Axis where N == 3 {
    /// First axis (index 0, typically X/horizontal).
    @inlinable
    public static var primary: Self { Self(unchecked: 0) }

    /// Second axis (index 1, typically Y/vertical).
    @inlinable
    public static var secondary: Self { Self(unchecked: 1) }

    /// Third axis (index 2, typically Z/depth).
    @inlinable
    public static var tertiary: Self { Self(unchecked: 2) }
}

// MARK: - 4D

extension Axis where N == 4 {
    /// First axis (index 0, typically X).
    @inlinable
    public static var primary: Self { Self(unchecked: 0) }

    /// Second axis (index 1, typically Y).
    @inlinable
    public static var secondary: Self { Self(unchecked: 1) }

    /// Third axis (index 2, typically Z).
    @inlinable
    public static var tertiary: Self { Self(unchecked: 2) }

    /// Fourth axis (index 3, typically W).
    @inlinable
    public static var quaternary: Self { Self(unchecked: 3) }
}
