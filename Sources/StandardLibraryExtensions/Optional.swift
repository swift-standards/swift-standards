// Optional.swift
// swift-standards
//
// Extensions for Swift standard library Optional

extension Optional {
    /// Unwraps the optional value or throws the specified error.
    ///
    /// Returns the wrapped value if present, otherwise throws the provided error.
    /// Use this when you need to convert an optional into a throwing operation with a custom error.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let maybeValue: Int? = nil
    /// let value = try maybeValue.unwrap(or: MyError.notFound)
    /// // Throws MyError.notFound
    /// ```
    public func unwrap<E: Error>(or error: E) throws(E) -> Wrapped {
        guard let value = self else { throw error }
        return value
    }

    /// Applies an optional transformation function to the optional value.
    ///
    /// Returns the result of applying the transformation if both the value and function are present, otherwise returns `nil`.
    /// Use this when both the transformation function and the value may be absent.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let fn: ((Int) -> String)? = { String($0) }
    /// let value: Int? = 42
    /// value.apply(fn)  // "42"
    ///
    /// let noValue: Int? = nil
    /// noValue.apply(fn)  // nil
    /// ```
    public func apply<Result>(_ transform: ((Wrapped) -> Result)?) -> Result? {
        guard let transform = transform, let value = self else { return nil }
        return transform(value)
    }

    /// Combines two optional values into a tuple.
    ///
    /// Returns a tuple containing both values if both optionals are present, otherwise returns `nil`.
    /// Use this when you need to work with two optional values together.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let a: Int? = 1
    /// let b: String? = "hello"
    /// a.zip(b)  // (1, "hello")
    ///
    /// let c: Int? = nil
    /// c.zip(b)  // nil
    /// ```
    public func zip<Other>(_ other: Other?) -> (Wrapped, Other)? {
        guard let value = self, let otherValue = other else { return nil }
        return (value, otherValue)
    }
}
