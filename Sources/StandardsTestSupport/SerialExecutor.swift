// SerialExecutor.swift
// StandardsTestSupport
//
// Provides deterministic async testing by routing tasks through a serial executor.
// Based on the approach from pointfreeco/swift-concurrency-extras.

#if !os(WASI) && !os(Windows) && !os(Android)
    import Foundation

    /// Performs an operation with all spawned tasks running serially on the main executor.
    ///
    /// This function makes async tests deterministic by ensuring tasks execute in a
    /// predictable order rather than being subject to the Swift runtime's scheduling.
    ///
    /// ```swift
    /// await withSerialExecutor {
    ///     // All async work here runs serially and deterministically
    /// }
    /// ```
    ///
    /// - Warning: Only use this in tests. Do not use in production code.
    /// - Parameter operation: The async operation to perform serially.
    @MainActor
    public func withSerialExecutor(
        @_implicitSelfCapture operation: @isolated(any) () async throws -> Void
    ) async rethrows {
        let previous = _useSerialExecutor
        defer { _useSerialExecutor = previous }
        _useSerialExecutor = true
        try await operation()
    }

    /// Performs a synchronous operation with serial executor enabled.
    ///
    /// Useful for wrapping entire test methods.
    ///
    /// - Warning: Only use this in tests. Do not use in production code.
    /// - Parameter operation: The operation to perform.
    public func withSerialExecutor(
        operation: () throws -> Void
    ) rethrows {
        let previous = _useSerialExecutor
        defer { _useSerialExecutor = previous }
        _useSerialExecutor = true
        try operation()
    }

    /// Controls whether the serial executor is active.
    ///
    /// When `true`, all global task enqueues are redirected to the main actor,
    /// making task execution serial and deterministic.
    ///
    /// - Warning: Only use this in tests. Do not use in production code.
    public var _useSerialExecutor: Bool {
        get { _taskEnqueueHook != nil }
        set {
            _taskEnqueueHook =
                newValue
                ? { job, _ in MainActor.shared.enqueue(job) }
                : nil
        }
    }

    // MARK: - Private Implementation

    private typealias OriginalHook = @convention(thin) (UnownedJob) -> Void
    private typealias TaskEnqueueHook = @convention(thin) (UnownedJob, OriginalHook) -> Void

    private var _taskEnqueueHook: TaskEnqueueHook? {
        get { _taskEnqueueHookPointer.pointee }
        set { _taskEnqueueHookPointer.pointee = newValue }
    }

    nonisolated(unsafe)
        private let _taskEnqueueHookPointer: UnsafeMutablePointer<TaskEnqueueHook?> = {
            let handle = dlopen(nil, 0)
            let symbol = dlsym(handle, "swift_task_enqueueGlobal_hook")
            return symbol!.assumingMemoryBound(to: TaskEnqueueHook?.self)
        }()

#endif
