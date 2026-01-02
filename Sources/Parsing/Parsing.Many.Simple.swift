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
    /// let digits1 = Parsing.Many.Simple(1...) { Digit() }
    ///
    /// // Exactly 4 digits
    /// let pin = Parsing.Many.Simple(4...4) { Digit() }
    /// ```
    public struct Simple<Input: Parsing.Input, Element: Parsing.Parser>: Sendable
    where Element: Sendable, Element.Input == Input {
        @usableFromInline
        let element: Element

        @usableFromInline
        let minimum: Int

        @usableFromInline
        let maximum: Int?

        @inlinable
        public init(
            _ range: PartialRangeFrom<Int>,
            @Parsing.Take.Builder<Input> element: () -> Element
        ) {
            self.element = element()
            self.minimum = range.lowerBound
            self.maximum = nil
        }

        @inlinable
        public init(
            _ range: ClosedRange<Int>,
            @Parsing.Take.Builder<Input> element: () -> Element
        ) {
            self.element = element()
            self.minimum = range.lowerBound
            self.maximum = range.upperBound
        }

        @inlinable
        public init(
            @Parsing.Take.Builder<Input> element: () -> Element
        ) {
            self.element = element()
            self.minimum = 0
            self.maximum = nil
        }
    }
}

extension Parsing.Many.Simple: Parsing.Parser {
    public typealias Output = [Element.Output]
    public typealias Failure = Parsing.Many.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
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
            throw Failure.countTooLow(expected: minimum, got: results.count)
        }

        return results
    }
}

// MARK: - Printer Conformance

extension Parsing.Many.Simple: Parsing.Printer
where Element: Parsing.Printer {
    @inlinable
    public func print(_ output: [Element.Output], into input: inout Input) throws(Failure) {
        // Validate count constraints
        if output.count < minimum {
            throw .countTooLow(expected: minimum, got: output.count)
        }
        if let max = maximum, output.count > max {
            throw .countTooHigh(expected: max, got: output.count)
        }

        // Print in reverse order
        // Element print failures are caught - Many only throws count errors
        for item in output.reversed() {
            do {
                try element.print(item, into: &input)
            } catch {
                // Element failure - silent, consistent with parse behavior
            }
        }
    }
}
