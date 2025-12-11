// Algebra.swift
// Algebraic structures and protocols.

// Re-export Dimension (Tagged, Enumerable, etc.)
public import Dimension

/// Namespace for algebraic structures and type-safe primitives.
///
/// This module provides well-typed alternatives to raw numeric and boolean types,
/// with clear semantics and algebraic properties. Use these types when domain
/// concepts (like polarity, phase, or parity) are more meaningful than raw values.
///
/// ## Example
///
/// ```swift
/// let charge: Polarity = .positive
/// let phase: Phase = .quarter
/// let parity: Parity = Parity(42)  // .even
/// ```
public enum Algebra {}
