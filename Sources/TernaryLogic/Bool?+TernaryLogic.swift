//
//  File.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2025.
//

extension Optional: TernaryLogic where Wrapped == Bool {
    /// The true value (`true`).
    @inlinable
    public static var `true`: Bool? { true }

    /// The false value (`false`).
    @inlinable
    public static var `false`: Bool? { false }

    /// The unknown value (`nil`).
    @inlinable
    public static var unknown: Bool? { nil }

    /// Returns self, since `Bool?` is the canonical representation.
    @inlinable
    public var boolValue: Bool? { self }

    /// Creates an optional Bool from an optional Bool (identity).
    @inlinable
    public init(boolValue: Bool?) {
        self = boolValue
    }
}
