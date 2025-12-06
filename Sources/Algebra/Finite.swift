// Finite.swift
// Namespace for finite type infrastructure.

/// Namespace for finite type concepts.
///
/// `Finite` provides infrastructure for types with a fixed, finite number
/// of inhabitants determined at compile time. This is the Swift equivalent
/// of dependent type constructs like Idris's `Fin n`.
///
/// ## Contents
///
/// - ``Finite/Indexable``: Protocol for types with N indexed inhabitants
/// - ``Finite/Sequence``: Zero-allocation iteration over finite types
///
/// ## Type-Theoretic Background
///
/// In dependent type theory, a **finite type** is a type with a known,
/// fixed number of inhabitants. The canonical finite type with N elements
/// is typically called `Fin n` — the type of natural numbers less than n.
///
/// Swift's integer generic parameters (SE-0452) provide a limited form of
/// dependent types. The `Finite` namespace bridges this to enable:
/// - Type-safe bounded indexing
/// - Exhaustive iteration over finite domains
/// - Generic programming over finite types
///
/// ## References
///
/// - [SE-0452: Integer Generic Parameters](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0452-integer-generic-parameters.md)
/// - [Wikipedia: Dependent Types](https://en.wikipedia.org/wiki/Dependent_type)
/// - [Idris Fin Type](https://docs.idris-lang.org/en/latest/tutorial/typesfuns.html)
/// - [Agda Data.Fin](https://agda.github.io/agda-stdlib/Data.Fin.html)
///
public enum Finite {}
