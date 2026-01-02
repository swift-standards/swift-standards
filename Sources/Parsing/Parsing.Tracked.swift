//
//  Parsing.Tracked.swift
//  swift-standards
//
//  Input wrapper that tracks byte offset.
//

extension Parsing {
    /// An input wrapper that tracks the current byte offset.
    ///
    /// `Tracked` wraps any `Input` type and maintains a running count
    /// of bytes consumed, enabling location-aware parsing.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// var input = Parsing.Tracked(myInput)
    /// let result = try parser.parse(&input)
    /// print("Parsed up to offset \(input.offset)")
    /// ```
    ///
    /// ## Zero Overhead When Not Used
    ///
    /// Regular parsers don't use `Tracked` - location tracking is opt-in.
    /// Only wrap input in `Tracked` when you need position information.
    ///
    /// ## With Located Errors
    ///
    /// Combine with `Located<E>` for precise error locations:
    /// ```swift
    /// var input = Parsing.Tracked(source)
    /// do {
    ///     return try parser.parse(&input)
    /// } catch {
    ///     throw Located(error, at: input.offset)
    /// }
    /// ```
    public struct Tracked<Base: Input>: Sendable
    where Base: Sendable {
        /// The underlying input.
        @usableFromInline
        internal var base: Base

        /// Current byte offset from the start of input.
        @usableFromInline
        internal var offset: Int

        /// The underlying input (read-only access).
        @inlinable
        public var input: Base { base }

        /// Current byte offset from the start of input.
        @inlinable
        public var currentOffset: Int { offset }

        /// Creates a tracked input.
        ///
        /// - Parameter base: The input to track.
        @inlinable
        public init(_ base: Base) {
            self.base = base
            self.offset = 0
        }

        /// Creates a tracked input with an initial offset.
        ///
        /// Useful for resuming parsing or when input is a slice.
        ///
        /// - Parameters:
        ///   - base: The input to track.
        ///   - offset: Initial offset value.
        @inlinable
        public init(_ base: Base, offset: Int) {
            self.base = base
            self.offset = offset
        }
    }
}

// MARK: - Input Conformance

extension Parsing.Tracked: Parsing.Input {
    public typealias Element = Base.Element

    @inlinable
    public var isEmpty: Bool {
        base.isEmpty
    }

    @inlinable
    public var count: Int? {
        base.count
    }

    @inlinable
    public var first: Element? {
        base.first
    }

    @inlinable
    public mutating func removeFirst() -> Element {
        offset += 1
        return base.removeFirst()
    }

    @inlinable
    public mutating func removeFirst(_ n: Int) {
        offset += n
        base.removeFirst(n)
    }

    @inlinable
    public var remaining: Parsing.Tracked<Base> {
        self
    }
}

// MARK: - Convenience

extension Parsing.Tracked {
    /// Saves the current position for later restoration.
    ///
    /// Use with `restore(to:)` for backtracking.
    @inlinable
    public func savepoint() -> (base: Base, offset: Int) {
        (base, offset)
    }

    /// Restores to a previously saved position.
    @inlinable
    public mutating func restore(to savepoint: (base: Base, offset: Int)) {
        self.base = savepoint.base
        self.offset = savepoint.offset
    }
}
