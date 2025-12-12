//
//  Binary.Serializable Tests.swift
//  swift-standards
//
//  Tests demonstrating the Binary.Serializable protocol for byte serialization.
//  These tests serve as both verification and documentation of ideal API usage patterns.
//

import Testing

@testable import Binary

// MARK: - Example Serializable Types

/// A simple greeting that serializes to bytes.
/// Demonstrates the minimal Serializable conformance pattern.
private struct Greeting: Binary.Serializable {
    let name: String

    static func serialize<Buffer>(_ greeting: Self, into buffer: inout Buffer)
    where Buffer: RangeReplaceableCollection, Buffer.Element == UInt8 {
        buffer.append(contentsOf: "Hello, ".utf8)
        buffer.append(contentsOf: greeting.name.utf8)
        buffer.append(UInt8(ascii: "!"))
    }
}

/// A composable HTML-like element demonstrating nested streaming.
/// Shows how streaming types naturally compose.
private struct Element: Binary.Serializable {
    let tag: String
    let content: String

    static func serialize<Buffer>(_ element: Self, into buffer: inout Buffer)
    where Buffer: RangeReplaceableCollection, Buffer.Element == UInt8 {
        buffer.append(UInt8(ascii: "<"))
        buffer.append(contentsOf: element.tag.utf8)
        buffer.append(UInt8(ascii: ">"))

        // Content
        buffer.append(contentsOf: element.content.utf8)

        // Closing tag
        buffer.append(UInt8(ascii: "<"))
        buffer.append(UInt8(ascii: "/"))
        buffer.append(contentsOf: element.tag.utf8)
        buffer.append(UInt8(ascii: ">"))
    }
}

/// A container that holds multiple streaming children.
/// Demonstrates compositional serialization of nested structures.
private struct Container: Binary.Serializable {
    let children: [Element]

    static func serialize<Buffer>(_ container: Self, into buffer: inout Buffer)
    where Buffer: RangeReplaceableCollection, Buffer.Element == UInt8 {
        buffer.append(contentsOf: "<div>".utf8)
        for child in container.children {
            buffer.append(contentsOf: child.bytes)
        }
        buffer.append(contentsOf: "</div>".utf8)
    }
}

/// A type demonstrating efficient serialization with capacity hints.
private struct LargeContent: Binary.Serializable {
    let lines: [String]

    static func serialize<Buffer>(_ content: Self, into buffer: inout Buffer)
    where Buffer: RangeReplaceableCollection, Buffer.Element == UInt8 {
        for (index, line) in content.lines.enumerated() {
            if index > 0 {
                buffer.append(UInt8(ascii: "\n"))
            }
            buffer.append(contentsOf: line.utf8)
        }
    }
}

// MARK: - Basic Serialization Tests

@Suite
struct `Binary.Serializable - Basic Usage` {

    @Test
    func `Serialize into byte array using serialize(into:)`() {
        let greeting = Greeting(name: "World")

        // Ideal usage: serialize into a mutable buffer
        var buffer: [UInt8] = []
        greeting.serialize(into: &buffer)

        #expect(buffer == Array("Hello, World!".utf8))
    }

    @Test
    func `Get bytes using .bytes property`() {
        let greeting = Greeting(name: "Swift")

        // Convenience: get bytes directly
        let bytes = greeting.bytes

        #expect(bytes == Array("Hello, Swift!".utf8))
    }

    @Test
    func `Get bytes from static serialize`() {
        let content = LargeContent(lines: ["Line 1", "Line 2", "Line 3"])

        let bytes: [UInt8] = LargeContent.serialize(content)

        #expect(bytes == Array("Line 1\nLine 2\nLine 3".utf8))
    }

    @Test
    func `Convert to String`() {
        let element = Element(tag: "p", content: "Hello")

        // Convert streaming value to String
        let string = String(element)

        #expect(string == "<p>Hello</p>")
    }

    @Test
    func `Use static serialize function`() {
        let greeting = Greeting(name: "API")

        // Static function style (compatible with Binary.ASCII.Serializable)
        let bytes: [UInt8] = Greeting.serialize(greeting)

        #expect(bytes == Array("Hello, API!".utf8))
    }
}

// MARK: - Composition Tests

@Suite
struct `Binary.Serializable - Composition` {

    @Test
    func `Nested streaming types compose naturally`() {
        let container = Container(children: [
            Element(tag: "h1", content: "Title"),
            Element(tag: "p", content: "Paragraph"),
        ])

        let result = String(container)

        #expect(result == "<div><h1>Title</h1><p>Paragraph</p></div>")
    }

    @Test
    func `Serialize multiple values into same buffer`() {
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

    @Test
    func `Pre-allocate buffer for efficiency`() {
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

@Suite
struct `Binary.Serializable - Buffer Types` {

    @Test
    func `Serialize into [UInt8]`() {
        let greeting = Greeting(name: "Array")

        var buffer: [UInt8] = []
        greeting.serialize(into: &buffer)

        #expect(buffer == Array("Hello, Array!".utf8))
    }

    @Test
    func `Serialize into ContiguousArray`() {
        let greeting = Greeting(name: "Contiguous")

        var buffer: ContiguousArray<UInt8> = []
        greeting.serialize(into: &buffer)

        #expect(Array(buffer) == Array("Hello, Contiguous!".utf8))
    }

    @Test
    func `Append to existing buffer content`() {
        let greeting = Greeting(name: "Append")

        // Start with existing content
        var buffer: [UInt8] = Array("Prefix: ".utf8)
        greeting.serialize(into: &buffer)

        #expect(buffer == Array("Prefix: Hello, Append!".utf8))
    }
}

// MARK: - Edge Cases

@Suite
struct `Binary.Serializable - Edge Cases` {

    @Test
    func `Empty content serializes correctly`() {
        let empty = Element(tag: "br", content: "")

        #expect(empty.bytes == Array("<br></br>".utf8))
    }

    @Test
    func `Unicode content serializes as UTF-8`() {
        let unicode = Element(tag: "span", content: "Hello 👋 World 🌍")

        let bytes = unicode.bytes
        let roundTrip = String(decoding: bytes, as: UTF8.self)

        #expect(roundTrip == "<span>Hello 👋 World 🌍</span>")
    }

    @Test
    func `Large content doesn't overflow`() {
        let lines = (1...10000).map { "Line number \($0) with some content" }
        let content = LargeContent(lines: lines)

        let bytes = content.bytes

        #expect(bytes.count > 100000)
    }
}

// MARK: - API Design Demonstration

@Suite
struct `Binary.Serializable - API Patterns` {

    @Test
    func `Pattern: Direct buffer writing for maximum control`() {
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

    @Test
    func `Pattern: Quick conversion via .bytes`() {
        // When you just need bytes quickly
        let element = Element(tag: "code", content: "swift")
        let bytes = element.bytes

        #expect(bytes == Array("<code>swift</code>".utf8))
    }

    @Test
    func `Pattern: String output via String(_:)`() {
        // When you need a String result
        let element = Element(tag: "em", content: "emphasis")
        let string = String(element)

        #expect(string == "<em>emphasis</em>")
    }

    @Test
    func `Pattern: Reusable buffer for repeated serialization`() {
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
