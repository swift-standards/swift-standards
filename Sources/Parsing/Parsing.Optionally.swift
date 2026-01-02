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

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        let saved = input
        do {
            return try wrapped.parse(&input)
        } catch {
            input = saved
            return nil
        }
    }
}
