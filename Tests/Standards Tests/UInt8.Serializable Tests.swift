//
//  UInt8.Serializable Tests.swift
//  swift-standards
//
//  Tests demonstrating the UInt8.Serializable protocol for byte serialization.
//  These tests serve as both verification and documentation of ideal API usage patterns.
//

import Testing

@testable import Standards

// MARK: - Example Serializable Types

/// A simple greeting that serializes to bytes.
/// Demonstrates the minimal Serializable conformance pattern.
private struct Greeting: UInt8.Serializable {
    let name: String

    static var serialize: @Sendable (Self) -> [UInt8] {
        { greeting in
            var bytes: [UInt8] = []
            bytes.append(contentsOf: "Hello, ".utf8)
            bytes.append(contentsOf: greeting.name.utf8)
            bytes.append(UInt8(ascii: "!"))
            return bytes
        }
    }
}

/// A composable HTML-like element demonstrating nested streaming.
/// Shows how streaming types naturally compose.
private struct Element: UInt8.Serializable {
    let tag: String
    let content: String

    static var serialize: @Sendable (Self) -> [UInt8] {
        { element in
            var bytes: [UInt8] = []
            // Opening tag
            bytes.append(UInt8(ascii: "<"))
            bytes.append(contentsOf: element.tag.utf8)
            bytes.append(UInt8(ascii: ">"))

            // Content
            bytes.append(contentsOf: element.content.utf8)

            // Closing tag
            bytes.append(UInt8(ascii: "<"))
            bytes.append(UInt8(ascii: "/"))
            bytes.append(contentsOf: element.tag.utf8)
            bytes.append(UInt8(ascii: ">"))
            return bytes
        }
    }
}

/// A container that holds multiple streaming children.
/// Demonstrates compositional serialization of nested structures.
private struct Container: UInt8.Serializable {
    let children: [Element]

    static var serialize: @Sendable (Self) -> [UInt8] {
        { container in
            var bytes: [UInt8] = []
            bytes.append(contentsOf: "<div>".utf8)
            for child in container.children {
                bytes.append(contentsOf: Element.serialize(child))
            }
            bytes.append(contentsOf: "</div>".utf8)
            return bytes
        }
    }
}

/// A type demonstrating efficient serialization with capacity hints.
private struct LargeContent: UInt8.Serializable {
    let lines: [String]

    static var serialize: @Sendable (Self) -> [UInt8] {
        { content in
            var bytes: [UInt8] = []
            for (index, line) in content.lines.enumerated() {
                if index > 0 {
                    bytes.append(UInt8(ascii: "\n"))
                }
                bytes.append(contentsOf: line.utf8)
            }
            return bytes
        }
    }
}

// MARK: - Basic Serialization Tests

@Suite("UInt8.Serializable - Basic Usage")
struct SerializableBasicTests {

    @Test("Serialize into byte array using serialize(into:)")
    func serializeIntoBuffer() {
        let greeting = Greeting(name: "World")

        // Ideal usage: serialize into a mutable buffer
        var buffer: [UInt8] = []
        greeting.serialize(into: &buffer)

        #expect(buffer == Array("Hello, World!".utf8))
    }

    @Test("Get bytes using .bytes property")
    func bytesProperty() {
        let greeting = Greeting(name: "Swift")

        // Convenience: get bytes directly
        let bytes = greeting.bytes

        #expect(bytes == Array("Hello, Swift!".utf8))
    }

    @Test("Get bytes from static serialize")
    func staticSerializeBytes() {
        let content = LargeContent(lines: ["Line 1", "Line 2", "Line 3"])

        let bytes = LargeContent.serialize(content)

        #expect(bytes == Array("Line 1\nLine 2\nLine 3".utf8))
    }

    @Test("Convert to String")
    func stringConversion() {
        let element = Element(tag: "p", content: "Hello")

        // Convert streaming value to String
        let string = String(element)

        #expect(string == "<p>Hello</p>")
    }

    @Test("Use static serialize function")
    func staticSerialize() {
        let greeting = Greeting(name: "API")

        // Static function style (compatible with UInt8.ASCII.Serializable)
        let bytes = Greeting.serialize(greeting)

        #expect(bytes == Array("Hello, API!".utf8))
    }
}

// MARK: - Composition Tests

@Suite("UInt8.Serializable - Composition")
struct SerializableCompositionTests {

    @Test("Nested streaming types compose naturally")
    func nestedComposition() {
        let container = Container(children: [
            Element(tag: "h1", content: "Title"),
            Element(tag: "p", content: "Paragraph"),
        ])

        let result = String(container)

        #expect(result == "<div><h1>Title</h1><p>Paragraph</p></div>")
    }

    @Test("Serialize multiple values into same buffer")
    func multipleValuesIntoBuffer() {
        let header = Element(tag: "header", content: "Header")
        let main = Element(tag: "main", content: "Content")
        let footer = Element(tag: "footer", content: "Footer")

        // Accumulate multiple serializations
        var buffer: [UInt8] = []
        header.serialize(into: &buffer)
        main.serialize(into: &buffer)
        footer.serialize(into: &buffer)

        let result = String(decoding: buffer, as: UTF8.self)
        #expect(result == "<header>Header</header><main>Content</main><footer>Footer</footer>")
    }

    @Test("Pre-allocate buffer for efficiency")
    func preAllocatedBuffer() {
        let lines = (1...100).map { "Line \($0)" }
        let content = LargeContent(lines: lines)

        // Pre-allocate for known large output
        var buffer: [UInt8] = []
        buffer.reserveCapacity(1000)
        content.serialize(into: &buffer)

        #expect(buffer.count > 500)
        #expect(String(decoding: buffer, as: UTF8.self).hasPrefix("Line 1\nLine 2"))
    }
}

// MARK: - Buffer Type Tests

@Suite("UInt8.Serializable - Buffer Types")
struct SerializableBufferTests {

    @Test("Serialize into [UInt8]")
    func serializeIntoArray() {
        let greeting = Greeting(name: "Array")

        var buffer: [UInt8] = []
        greeting.serialize(into: &buffer)

        #expect(buffer == Array("Hello, Array!".utf8))
    }

    @Test("Serialize into ContiguousArray")
    func serializeIntoContiguousArray() {
        let greeting = Greeting(name: "Contiguous")

        var buffer: ContiguousArray<UInt8> = []
        greeting.serialize(into: &buffer)

        #expect(Array(buffer) == Array("Hello, Contiguous!".utf8))
    }

    @Test("Append to existing buffer content")
    func appendToExistingContent() {
        let greeting = Greeting(name: "Append")

        // Start with existing content
        var buffer: [UInt8] = Array("Prefix: ".utf8)
        greeting.serialize(into: &buffer)

        #expect(buffer == Array("Prefix: Hello, Append!".utf8))
    }
}

// MARK: - Edge Cases

@Suite("UInt8.Serializable - Edge Cases")
struct SerializableEdgeCaseTests {

    @Test("Empty content serializes correctly")
    func emptyContent() {
        let empty = Element(tag: "br", content: "")

        #expect(empty.bytes == Array("<br></br>".utf8))
    }

    @Test("Unicode content serializes as UTF-8")
    func unicodeContent() {
        let unicode = Element(tag: "span", content: "Hello 👋 World 🌍")

        let bytes = unicode.bytes
        let roundTrip = String(decoding: bytes, as: UTF8.self)

        #expect(roundTrip == "<span>Hello 👋 World 🌍</span>")
    }

    @Test("Large content doesn't overflow")
    func largeContent() {
        let lines = (1...10000).map { "Line number \($0) with some content" }
        let content = LargeContent(lines: lines)

        let bytes = content.bytes

        #expect(bytes.count > 100000)
    }
}

// MARK: - API Design Demonstration

@Suite("UInt8.Serializable - API Patterns")
struct SerializableAPIPatternTests {

    @Test("Pattern: Direct buffer writing for maximum control")
    func directBufferWriting() {
        // When you need maximum control over the buffer
        var buffer: [UInt8] = []
        buffer.reserveCapacity(256)

        let parts = [
            Element(tag: "a", content: "Link"),
            Element(tag: "b", content: "Bold"),
        ]

        for part in parts {
            part.serialize(into: &buffer)
        }

        #expect(buffer == Array("<a>Link</a><b>Bold</b>".utf8))
    }

    @Test("Pattern: Quick conversion via .bytes")
    func quickConversion() {
        // When you just need bytes quickly
        let element = Element(tag: "code", content: "swift")
        let bytes = element.bytes

        #expect(bytes == Array("<code>swift</code>".utf8))
    }

    @Test("Pattern: String output via String(_:)")
    func stringOutput() {
        // When you need a String result
        let element = Element(tag: "em", content: "emphasis")
        let string = String(element)

        #expect(string == "<em>emphasis</em>")
    }

    @Test("Pattern: Reusable buffer for repeated serialization")
    func reusableBuffer() {
        // Reuse buffer to avoid allocations
        var buffer: [UInt8] = []

        let elements = ["one", "two", "three"].map { Element(tag: "li", content: $0) }
        var results: [String] = []

        for element in elements {
            buffer.removeAll(keepingCapacity: true)
            element.serialize(into: &buffer)
            results.append(String(decoding: buffer, as: UTF8.self))
        }

        #expect(results == ["<li>one</li>", "<li>two</li>", "<li>three</li>"])
    }
}
