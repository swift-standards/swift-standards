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
    /// // Comma-separated values
    /// let csv = Parsing.Many.Separated {
    ///     Field()
    /// } separator: {
    ///     ","
    /// }
    ///
    /// // One or more with separator
    /// let list = Parsing.Many.Separated(1...) {
    ///     Int.parser()
    /// } separator: {
    ///     ","
    /// }
    /// ```
    public struct Separated<Input: Parsing.Input, Element: Parsing.Parser, Separator: Parsing.Parser>: Sendable
    where Element: Sendable, Separator: Sendable,
          Element.Input == Input, Separator.Input == Input {
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
            _ range: PartialRangeFrom<Int>,
            @Parsing.Take.Builder<Input> element: () -> Element,
            @Parsing.Take.Builder<Input> separator: () -> Separator
        ) {
            self.element = element()
            self.separator = separator()
            self.minimum = range.lowerBound
            self.maximum = nil
        }

        @inlinable
        public init(
            _ range: ClosedRange<Int>,
            @Parsing.Take.Builder<Input> element: () -> Element,
            @Parsing.Take.Builder<Input> separator: () -> Separator
        ) {
            self.element = element()
            self.separator = separator()
            self.minimum = range.lowerBound
            self.maximum = range.upperBound
        }

        @inlinable
        public init(
            @Parsing.Take.Builder<Input> element: () -> Element,
            @Parsing.Take.Builder<Input> separator: () -> Separator
        ) {
            self.element = element()
            self.separator = separator()
            self.minimum = 0
            self.maximum = nil
        }
    }
}

extension Parsing.Many.Separated: Parsing.Parser {
    public typealias Output = [Element.Output]
    public typealias Failure = Parsing.Many.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        var results: [Element.Output] = []

        // Parse first element
        do {
            let first = try element.parse(&input)
            results.append(first)
        } catch {
            if minimum > 0 {
                throw Failure.countTooLow(expected: minimum, got: 0)
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
            throw Failure.countTooLow(expected: minimum, got: results.count)
        }

        return results
    }
}

// MARK: - Printer Conformance

extension Parsing.Many.Separated: Parsing.Printer
where Element: Parsing.Printer, Separator: Parsing.Printer, Separator.Output == Void {
    public typealias PrintFailure = Parsing.OneOf.Errors<Parsing.Many.Error, Element.Failure, Separator.Failure>

    @inlinable
    public func print(_ output: [Element.Output], into input: inout Input) throws(Failure) {
        // Validate count constraints
        if output.count < minimum {
            throw Failure.countTooLow(expected: minimum, got: output.count)
        }
        if let max = maximum, output.count > max {
            throw Failure.countTooHigh(expected: max, got: output.count)
        }

        // Print in reverse order with separators between elements
        var isFirst = true
        for item in output.reversed() {
            if !isFirst {
                do {
                    try separator.print((), into: &input)
                } catch {
                    // Separator failure - ignore for now, Many only throws count errors
                    break
                }
            }
            do {
                try element.print(item, into: &input)
            } catch {
                // Element failure - ignore for now, Many only throws count errors
                break
            }
            isFirst = false
        }
    }
}
