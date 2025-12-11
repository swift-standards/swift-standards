// Bit.swift
public import Dimension

/// Binary digit: zero or one.
///
/// The fundamental unit of information in digital systems. Forms the Z₂ field
/// under XOR (addition) and AND (multiplication). Use `Bit` when working with
/// individual binary digits, flags, or boolean algebra.
///
/// ## Example
///
/// ```swift
/// let a: Bit = .one
/// let b: Bit = .zero
/// print(a.flipped)       // 0
/// print(a.xor(b))        // 1
/// print(Bit(true))       // 1
/// ```
public typealias Bit = UInt8

extension Bit {
    /// Binary zero (false, off, low).
    public static let zero: Self = 0

    /// Binary one (true, on, high).
    public static let one: Self = 1
}

extension Bit: @retroactive CaseIterable {
    /// All bit values: `[.zero, .one]`.
    public static let allCases: [UInt8] = [.zero, .one]
}

// MARK: - Flip

extension Bit {
    /// Flipped bit (NOT operation: 0→1, 1→0).
    @inlinable
    public var flipped: Bit { self ^ 1 }

    /// Returns the flipped bit.
    @inlinable
    public static prefix func ! (value: Bit) -> Bit {
        value.flipped
    }

    /// Flipped bit (digital logic terminology).
    @inlinable
    public var toggled: Bit { flipped }
}

// MARK: - Boolean Operations

extension Bit {
    /// Logical AND: returns `.one` only if both bits are `.one`.
    @inlinable
    public func and(_ other: Bit) -> Bit {
        (self == .one && other == .one) ? .one : .zero
    }

    /// Logical OR: returns `.one` if either bit is `.one`.
    @inlinable
    public func or(_ other: Bit) -> Bit {
        (self == .one || other == .one) ? .one : .zero
    }

    /// Logical XOR: returns `.one` if bits differ (addition in Z₂).
    @inlinable
    public func xor(_ other: Bit) -> Bit {
        (self != other) ? .one : .zero
    }
}

// MARK: - Boolean Conversion

extension Bit {
    /// Creates a bit from a boolean (`true` → `.one`, `false` → `.zero`).
    @inlinable
    public init(_ bool: Bool) {
        self = bool ? .one : .zero
    }

    /// Boolean representation (`true` if `.one`, `false` if `.zero`).
    @inlinable
    public var boolValue: Bool {
        self == .one
    }
}

// MARK: - Tagged Value

extension Bit {
    /// A value paired with a bit flag.
    public typealias Value<Payload> = Pair<Bit, Payload>
}
