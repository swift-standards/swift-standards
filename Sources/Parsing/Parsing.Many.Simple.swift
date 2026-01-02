//
//  Parsing.Many.Simple.swift
//  swift-standards
//
//  Simple repetition parser (no separator).
//

extension Parsing.Many {
    /// A parser that applies another parser repeatedly (no separator).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Zero or more digits
    /// let digits = Parsing.Many.Simple { Digit() }
    ///
    /// // One or more digits
    /// let digits1 = Parsing.Many.Simple(atLeast: 1) { Digit() }
    ///
    /// // Exactly 4 digits
    /// let pin = Parsing.Many.Simple(exactly: 4) { Digit() }
    /// ```
    public struct Simple<Element: Parsing.Parser>: Sendable
    where Element: Sendable {
        @usableFromInline
        let element: Element

        @usableFromInline
        let minimum: Int

        @usableFromInline
        let maximum: Int?

        @inlinable
        public init(
            atLeast minimum: Int = 0,
            atMost maximum: Int? = nil,
            @Parsing.Take.Builder<Element.Input> element: () -> Element
        ) {
            self.element = element()
            self.minimum = minimum
            self.maximum = maximum
        }
    }
}

extension Parsing.Many.Simple: Parsing.Parser {
    public typealias Input = Element.Input
    public typealias Output = [Element.Output]

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        var results: [Element.Output] = []

        while maximum.map({ results.count < $0 }) ?? true {
            let saved = input

            do {
                let next = try element.parse(&input)
                results.append(next)
            } catch {
                input = saved
                break
            }
        }

        if results.count < minimum {
            throw Parsing.Error("Expected at least \(minimum) elements, got \(results.count)")
        }

        return results
    }
}
