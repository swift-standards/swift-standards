//
//  Parsing.Optionally.swift
//  swift-standards
//
//  Runtime optional parser (backtracks on failure).
//

extension Parsing {
    /// A parser that tries to parse but succeeds with nil on failure.
    ///
    /// Unlike `Optional` (compile-time optional), this is runtime optional.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let optionalSign = Parsing.Optionally { Sign() }
    /// ```
    public struct Optionally<Wrapped: Parsing.Parser>: Sendable
    where Wrapped: Sendable {
        @usableFromInline
        let wrapped: Wrapped

        @inlinable
        public init(@Parsing.Take.Builder<Wrapped.Input> _ wrapped: () -> Wrapped) {
            self.wrapped = wrapped()
        }
    }
}

extension Parsing.Optionally: Parsing.Parser {
    public typealias Input = Wrapped.Input
    public typealias Output = Wrapped.Output?
    public typealias Failure = Never

    @inlinable
    public func parse(_ input: inout Input) -> Output {
        let saved = input
        do {
            return try wrapped.parse(&input)
        } catch {
            input = saved
            return nil
        }
    }
}

// MARK: - Printer Conformance

extension Parsing.Optionally: Parsing.Printer
where Wrapped: Parsing.Printer {
    @inlinable
    public func print(_ output: Wrapped.Output?, into input: inout Input) throws(Failure) {
        guard let output = output else { return }
        // Optionally is infallible for parsing but can fail when printing
        // We catch the error since we can't propagate Wrapped.Failure through Never
        do {
            try wrapped.print(output, into: &input)
        } catch {
            // Silently fail - consistent with parsing behavior of returning nil
        }
    }
}
