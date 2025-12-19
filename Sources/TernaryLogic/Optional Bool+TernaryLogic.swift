extension Optional: TernaryLogic.`Protocol` where Wrapped == Bool {
    /// The true value (`true`).
    @inlinable
    public static var `true`: Bool? { true }

    /// The false value (`false`).
    @inlinable
    public static var `false`: Bool? { false }

    /// The unknown value (`nil`).
    @inlinable
    public static var unknown: Bool? { nil }

    /// Returns self as the canonical `Bool?` representation.
    @inlinable
    public static func from(_ self: Self) -> Bool? { self }

    /// Creates an optional Bool from an optional Bool (identity operation).
    @inlinable
    public init(_ bool: Bool?) {
        self = bool
    }
}

extension Optional where Wrapped == Bool {
    /// Creates an optional Bool from any `TernaryLogic.Protocol` conforming type.
    ///
    /// ## Example
    ///
    /// ```swift
    /// enum Tribool: TernaryLogic.Protocol {
    ///     case yes, no, maybe
    ///     // ... protocol requirements
    /// }
    /// let tribool = Tribool.maybe
    /// let bool: Bool? = Bool?(tribool)
    /// // bool = nil (unknown)
    /// ```
    public init<T: TernaryLogic.`Protocol`>(
        _ t: T
    ) {
        self = T.from(t)
    }
}
