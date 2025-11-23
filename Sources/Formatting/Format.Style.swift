//
//  Format.Style.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 23/11/2025.
//

extension Format {
    /// A type that can format values into representations.
    ///
    /// This is an alias to the `Formatting` protocol, providing a namespaced
    /// way to refer to format styles under the `Format` namespace.
    ///
    /// Both of these are equivalent:
    /// ```swift
    /// struct MyFormatter: Formatting { ... }
    /// struct MyFormatter: Format.Style { ... }
    /// ```
    ///
    /// This aligns with Foundation's `FormatStyle` pattern while maintaining
    /// backward compatibility with the `Formatting` protocol.
    public typealias Style = Formatting
}
