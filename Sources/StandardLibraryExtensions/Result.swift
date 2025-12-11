// Result.swift
// swift-standards
//
// Extensions for Swift standard library Result

extension Result {
    /// The success value if the result is successful, otherwise `nil`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result: Result<Int, Error> = .success(42)
    /// result.success  // 42
    ///
    /// let failed: Result<Int, Error> = .failure(MyError.failed)
    /// failed.success  // nil
    /// ```
    public var success: Success? {
        guard case .success(let value) = self else { return nil }
        return value
    }

    /// The failure error if the result is a failure, otherwise `nil`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let failed: Result<Int, Error> = .failure(MyError.failed)
    /// failed.failure  // MyError.failed
    ///
    /// let result: Result<Int, Error> = .success(42)
    /// result.failure  // nil
    /// ```
    public var failure: Failure? {
        guard case .failure(let error) = self else { return nil }
        return error
    }

    /// Combines two results into a single result containing a tuple of both successes.
    ///
    /// Returns a success containing both values if both results are successful.
    /// If either result is a failure, returns the first failure encountered.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let r1: Result<Int, Error> = .success(1)
    /// let r2: Result<String, Error> = .success("hello")
    /// r1.zip(r2)  // .success((1, "hello"))
    ///
    /// let r3: Result<Int, Error> = .failure(MyError.failed)
    /// r1.zip(r3)  // .failure(MyError.failed)
    /// ```
    public func zip<OtherSuccess>(
        _ other: Result<OtherSuccess, Failure>
    ) -> Result<(Success, OtherSuccess), Failure> {
        switch (self, other) {
        case (.success(let a), .success(let b)):
            return .success((a, b))
        case (.failure(let error), _):
            return .failure(error)
        case (_, .failure(let error)):
            return .failure(error)
        }
    }

    /// Combines two results by applying a transformation to both success values.
    ///
    /// Returns a success containing the combined result if both results are successful.
    /// If either result is a failure, returns the first failure encountered.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let r1: Result<Int, Error> = .success(2)
    /// let r2: Result<Int, Error> = .success(3)
    /// r1.zip(r2, with: +)  // .success(5)
    /// ```
    public func zip<OtherSuccess, Combined>(
        _ other: Result<OtherSuccess, Failure>,
        with combine: (Success, OtherSuccess) -> Combined
    ) -> Result<Combined, Failure> {
        zip(other).map { combine($0.0, $0.1) }
    }
}
