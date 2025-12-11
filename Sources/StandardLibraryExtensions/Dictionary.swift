// Dictionary.swift
// swift-standards
//
// Extensions for Swift standard library Dictionary

extension Dictionary {
    /// Returns a new dictionary by transforming the keys while preserving values.
    ///
    /// Applies the transformation to each key. If multiple keys transform to the same value, only the last one is preserved.
    /// Use this to change key types or normalize keys.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dict = [1: "one", 2: "two"]
    /// dict.mapKeys { "key\($0)" }  // ["key1": "one", "key2": "two"]
    /// ```
    public func mapKeys<NewKey: Hashable>(
        _ transform: (Key) throws -> NewKey
    ) rethrows -> [NewKey: Value] {
        try reduce(into: [:]) { result, pair in
            result[try transform(pair.key)] = pair.value
        }
    }

    /// Returns a new dictionary by transforming keys and filtering out `nil` results.
    ///
    /// Applies the transformation to each key, keeping only the entries where the transformation returns a non-`nil` value.
    /// Use this to selectively transform and filter dictionary keys.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dict = [1: "one", 2: "two", 3: "three"]
    /// dict.compactMapKeys { $0 > 1 ? $0 : nil }  // [2: "two", 3: "three"]
    /// ```
    public func compactMapKeys<NewKey: Hashable>(
        _ transform: (Key) throws -> NewKey?
    ) rethrows -> [NewKey: Value] {
        try reduce(into: [:]) { result, pair in
            if let newKey = try transform(pair.key) {
                result[newKey] = pair.value
            }
        }
    }

    /// Compacts dictionary values, removing nil entries
    ///
    /// Natural transformation from Dict(K, Maybe(V)) to Dict(K, V).
    /// Flattens optional values, filtering out None cases.
    ///
    /// Category theory: Natural transformation ν: Dict ∘ Maybe → Dict
    /// ν: Dict(K, Maybe(V)) → Dict(K, V)
    ///
    /// Example:
    /// ```swift
    /// let dict: [String: Int?] = ["a": 1, "b": nil, "c": 3]
    /// dict.compactMapValues { $0 }  // Already exists in stdlib
    /// ```
    /// Note: compactMapValues already exists in Swift stdlib,
    /// but documented here for completeness
}

extension Dictionary where Value: Equatable {
    /// Returns a new dictionary with keys and values swapped.
    ///
    /// If multiple keys have the same value, only the last key-value pair is preserved in the result.
    /// Use this to create a reverse lookup dictionary.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dict = ["a": 1, "b": 2]
    /// dict.inverted()  // [1: "a", 2: "b"]
    /// ```
    public func inverted() -> [Value: Key] where Value: Hashable {
        reduce(into: [:]) { result, pair in
            result[pair.value] = pair.key
        }
    }
}
