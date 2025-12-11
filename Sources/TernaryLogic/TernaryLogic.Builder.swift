// MARK: - TernaryLogic Builders

extension TernaryLogic {
    /// Namespace for ternary logic result builders.
    ///
    /// Provides result builders (`All`, `Any`, `None`) that implement Strong Kleene three-valued logic with Swift's result builder syntax. Use these to combine multiple ternary conditions declaratively.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = TernaryLogic.all {
    ///     true
    ///     nil  // unknown
    ///     true
    /// }
    /// // result = nil (unknown propagates)
    /// ```
    public enum Builder<T: TernaryLogic.`Protocol`> {
        /// A result builder that combines ternary conditions with AND semantics.
        ///
        /// Returns `false` if any condition is `false` (short-circuits), `unknown` if any condition is `unknown` and none are `false`, or `true` only if all conditions are `true`.
        ///
        /// ## Example
        ///
        /// ```swift
        /// let result = TernaryLogic.all {
        ///     true
        ///     nil    // unknown
        ///     true
        /// }
        /// // result = nil (unknown)
        /// ```
        @resultBuilder
        public enum All {
            @inlinable
            public static func buildExpression(_ expression: T) -> T {
                expression
            }

            @inlinable
            public static func buildExpression(_ expression: Bool) -> T {
                T(expression)
            }

            @inlinable
            public static func buildPartialBlock(first: T) -> T {
                first
            }

            @inlinable
            public static func buildPartialBlock(first: Void) -> T {
                .true
            }

            @inlinable
            public static func buildPartialBlock(first: Never) -> T {}

            @inlinable
            public static func buildPartialBlock(accumulated: T, next: T) -> T {
                // Strong Kleene AND: false dominates, then unknown, then true
                if T.from(accumulated) == false || T.from(next) == false {
                    return .false
                }
                if T.from(accumulated) == nil || T.from(next) == nil {
                    return .unknown
                }
                return .true
            }

            @inlinable
            public static func buildBlock() -> T {
                .true
            }

            @inlinable
            public static func buildOptional(_ component: T?) -> T {
                // Missing value means unknown in ternary logic
                component ?? .unknown
            }

            @inlinable
            public static func buildEither(first: T) -> T {
                first
            }

            @inlinable
            public static func buildEither(second: T) -> T {
                second
            }

            @inlinable
            public static func buildArray(_ components: [T]) -> T {
                var hasUnknown = false
                for component in components {
                    if T.from(component) == false {
                        return .false
                    }
                    if T.from(component) == nil {
                        hasUnknown = true
                    }
                }
                return hasUnknown ? .unknown : .true
            }

            @inlinable
            public static func buildLimitedAvailability(_ component: T) -> T {
                component
            }
        }

        /// A result builder that combines ternary conditions with OR semantics.
        ///
        /// Returns `true` if any condition is `true` (short-circuits), `unknown` if any condition is `unknown` and none are `true`, or `false` only if all conditions are `false`.
        ///
        /// ## Example
        ///
        /// ```swift
        /// let result = TernaryLogic.any {
        ///     false
        ///     nil    // unknown
        ///     false
        /// }
        /// // result = nil (unknown)
        /// ```
        @resultBuilder
        public enum `Any` {
            @inlinable
            public static func buildExpression(_ expression: T) -> T {
                expression
            }

            @inlinable
            public static func buildExpression(_ expression: Bool) -> T {
                T(expression)
            }

            @inlinable
            public static func buildPartialBlock(first: T) -> T {
                first
            }

            @inlinable
            public static func buildPartialBlock(first: Void) -> T {
                .false
            }

            @inlinable
            public static func buildPartialBlock(first: Never) -> T {}

            @inlinable
            public static func buildPartialBlock(accumulated: T, next: T) -> T {
                // Strong Kleene OR: true dominates, then unknown, then false
                if T.from(accumulated) == true || T.from(next) == true {
                    return .true
                }
                if T.from(accumulated) == nil || T.from(next) == nil {
                    return .unknown
                }
                return .false
            }

            @inlinable
            public static func buildBlock() -> T {
                .false
            }

            @inlinable
            public static func buildOptional(_ component: T?) -> T {
                component ?? .unknown
            }

            @inlinable
            public static func buildEither(first: T) -> T {
                first
            }

            @inlinable
            public static func buildEither(second: T) -> T {
                second
            }

            @inlinable
            public static func buildArray(_ components: [T]) -> T {
                var hasUnknown = false
                for component in components {
                    if T.from(component) == true {
                        return .true
                    }
                    if T.from(component) == nil {
                        hasUnknown = true
                    }
                }
                return hasUnknown ? .unknown : .false
            }

            @inlinable
            public static func buildLimitedAvailability(_ component: T) -> T {
                component
            }
        }

        /// A result builder that requires no conditions to be true (NOR semantics).
        ///
        /// Returns `true` if all conditions are `false`, `unknown` if any condition is `unknown` and none are `true`, or `false` if any condition is `true`.
        ///
        /// ## Example
        ///
        /// ```swift
        /// let result = TernaryLogic.none {
        ///     false
        ///     false
        /// }
        /// // result = true (none are true)
        /// ```
        @resultBuilder
        public enum None {
            @inlinable
            public static func buildExpression(_ expression: T) -> T {
                expression
            }

            @inlinable
            public static func buildExpression(_ expression: Bool) -> T {
                T(expression)
            }

            @inlinable
            public static func buildPartialBlock(first: T) -> T {
                first
            }

            @inlinable
            public static func buildPartialBlock(first: Void) -> T {
                .false
            }

            @inlinable
            public static func buildPartialBlock(first: Never) -> T {}

            @inlinable
            public static func buildPartialBlock(accumulated: T, next: T) -> T {
                // Collect for OR (will be negated in buildFinalResult)
                if T.from(accumulated) == true || T.from(next) == true {
                    return .true
                }
                if T.from(accumulated) == nil || T.from(next) == nil {
                    return .unknown
                }
                return .false
            }

            @inlinable
            public static func buildBlock() -> T {
                .false
            }

            @inlinable
            public static func buildOptional(_ component: T?) -> T {
                component ?? .unknown
            }

            @inlinable
            public static func buildEither(first: T) -> T {
                first
            }

            @inlinable
            public static func buildEither(second: T) -> T {
                second
            }

            @inlinable
            public static func buildArray(_ components: [T]) -> T {
                var hasUnknown = false
                for component in components {
                    if T.from(component) == true {
                        return .true
                    }
                    if T.from(component) == nil {
                        hasUnknown = true
                    }
                }
                return hasUnknown ? .unknown : .false
            }

            @inlinable
            public static func buildLimitedAvailability(_ component: T) -> T {
                component
            }

            @inlinable
            public static func buildFinalResult(_ component: T) -> T {
                // NOR: negate the OR result
                switch T.from(component) {
                case true: return .false
                case false: return .true
                case nil: return .unknown
                }
            }
        }
    }
}

// MARK: - Convenience Entry Points

extension TernaryLogic {
    /// Combines ternary conditions with AND semantics using a result builder.
    ///
    /// Returns `false` if any is `false`, `unknown` if any is `unknown` and none are `false`, or `true` if all are `true`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = TernaryLogic.all {
    ///     true
    ///     nil
    /// }
    /// // result = nil (unknown)
    /// ```
    @inlinable
    public static func all<T: TernaryLogic.`Protocol`>(@Builder<T>.All _ builder: () -> T) -> T {
        builder()
    }

    /// Combines ternary conditions with OR semantics using a result builder.
    ///
    /// Returns `true` if any is `true`, `unknown` if any is `unknown` and none are `true`, or `false` if all are `false`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = TernaryLogic.any {
    ///     false
    ///     nil
    /// }
    /// // result = nil (unknown)
    /// ```
    @inlinable
    public static func any<T: TernaryLogic.`Protocol`>(@Builder<T>.`Any` _ builder: () -> T) -> T {
        builder()
    }

    /// Combines ternary conditions with NOR semantics using a result builder.
    ///
    /// Returns `true` if all are `false`, `unknown` if any is `unknown` and none are `true`, or `false` if any is `true`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = TernaryLogic.none {
    ///     false
    ///     false
    /// }
    /// // result = true (none are true)
    /// ```
    @inlinable
    public static func none<T: TernaryLogic.`Protocol`>(@Builder<T>.None _ builder: () -> T) -> T {
        builder()
    }
}

// MARK: - Bool? Convenience (Type-level Entry Points)

extension Optional where Wrapped == Bool {
    /// Combines `Bool?` conditions with AND semantics using a result builder.
    ///
    /// Returns `false` if any is `false`, `nil` (unknown) if any is `nil` and none are `false`, or `true` if all are `true`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = Bool?.all {
    ///     true
    ///     nil
    /// }
    /// // result = nil (unknown)
    /// ```
    @inlinable
    public static func all(@TernaryLogic.Builder<Bool?>.All _ builder: () -> Bool?) -> Bool? {
        builder()
    }

    /// Combines `Bool?` conditions with OR semantics using a result builder.
    ///
    /// Returns `true` if any is `true`, `nil` (unknown) if any is `nil` and none are `true`, or `false` if all are `false`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = Bool?.any {
    ///     false
    ///     nil
    /// }
    /// // result = nil (unknown)
    /// ```
    @inlinable
    public static func any(@TernaryLogic.Builder<Bool?>.`Any` _ builder: () -> Bool?) -> Bool? {
        builder()
    }

    /// Combines `Bool?` conditions with NOR semantics using a result builder.
    ///
    /// Returns `true` if all are `false`, `nil` (unknown) if any is `nil` and none are `true`, or `false` if any is `true`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = Bool?.none {
    ///     false
    ///     false
    /// }
    /// // result = true (none are true)
    /// ```
    @inlinable
    public static func none(@TernaryLogic.Builder<Bool?>.None _ builder: () -> Bool?) -> Bool? {
        builder()
    }
}
