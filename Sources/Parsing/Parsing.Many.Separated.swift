//
//  Parsing.Many.Separated.swift
//  swift-standards
//
//  Repetition parser with separators.
//

extension Parsing.Many {
    /// A parser that applies another parser repeatedly with separators.
    ///
    /// `Separated` collects results into an array. It always succeeds (possibly with
    /// an empty array) unless a minimum count is specified.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // With separator
    /// let csv = Parsing.Many.Separated { Field() } separator: { "," }
    /// ```
    public struct Separated<Element: Parsing.Parser, Separator: Parsing.Parser>: Sendable
    where Element: Sendable, Separator: Sendable, Element.Input == Separator.Input {
        @usableFromInline
        let element: Element

        @usableFromInline
        let separator: Separator

        @usableFromInline
        let minimum: Int

        @usableFromInline
        let maximum: Int?

        @inlinable
        public init(
            atLeast minimum: Int = 0,
            atMost maximum: Int? = nil,
            @Parsing.Take.Builder<Element.Input> element: () -> Element,
            @Parsing.Take.Builder<Element.Input> separator: () -> Separator
        ) {
            self.element = element()
            self.separator = separator()
            self.minimum = minimum
            self.maximum = maximum
        }
    }
}

extension Parsing.Many.Separated: Parsing.Parser {
    public typealias Input = Element.Input
    public typealias Output = [Element.Output]

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        var results: [Element.Output] = []

        // Parse first element
        do {
            let first = try element.parse(&input)
            results.append(first)
        } catch {
            if minimum > 0 {
                throw error
            }
            return results
        }

        // Parse remaining elements (with separator)
        while maximum.map({ results.count < $0 }) ?? true {
            let saved = input

            // Try separator
            do {
                _ = try separator.parse(&input)
            } catch {
                input = saved
                break
            }

            // Try next element
            do {
                let next = try element.parse(&input)
                results.append(next)
            } catch {
                input = saved
                break
            }
        }

        // Check minimum
        if results.count < minimum {
            throw Parsing.Error("Expected at least \(minimum) elements, got \(results.count)")
        }

        return results
    }
}
