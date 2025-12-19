//
//  Exclusive.swift
//  swift-standards
//
//  Trait that provides mutual exclusion between suites.
//

public import Testing

/// Trait that provides mutual exclusion between suites.
///
/// When applied to sibling suites, only one suite executes at a time.
/// Tests within each suite still run in parallel (unless `.serialized` is also applied).
///
/// **Important**: This provides mutual exclusion, not ordering. The order in which
/// suites run is determined by Swift Testing, not by this trait.
/// The guarantee is that they will not overlap, not that they run in a specific sequence.
///
/// Example:
/// ```swift
/// @Suite enum Test {
///     @Suite(.exclusive) struct Unit {}
///     @Suite(.exclusive) struct EdgeCase {}
///     @Suite(.exclusive, .serialized) struct Performance {}
/// }
/// ```
///
/// Execution:
/// - One of Unit/EdgeCase/Performance acquires the lock and runs (tests in parallel)
/// - When it completes, another acquires the lock
/// - Performance tests run serially due to `.serialized`
///
/// Use the `group` parameter to limit exclusion to suites within the same group:
/// ```swift
/// // These are mutually exclusive with each other
/// @Suite(.exclusive(group: "TypeA")) struct Unit {}
/// @Suite(.exclusive(group: "TypeA")) struct EdgeCase {}
///
/// // This can run in parallel with TypeA suites
/// @Suite(.exclusive(group: "TypeB")) struct Other {}
/// ```
///
/// Without a group, suites use global exclusion and will not overlap with
/// any other ungrouped suites across all types.
public struct Exclusive: SuiteTrait, TestScoping {
    /// The default group used for global exclusion.
    public static let globalGroup = "__global__"

    /// The exclusion group. Suites with the same group are mutually exclusive.
    /// Uses a global default group if not specified.
    public let group: String

    /// Does not propagate to nested suites or tests.
    public var isRecursive: Bool { false }

    /// Creates a trait with the specified exclusion group.
    /// - Parameter group: The group identifier. Defaults to global exclusion.
    public init(group: String = Exclusive.globalGroup) {
        self.group = group
    }

    public func provideScope(
        for test: Test,
        testCase: Test.Case?,
        performing function: @Sendable () async throws -> Void
    ) async throws {
        guard test.isSuite else {
            try await function()
            return
        }

        try await ExclusionController.shared.withExclusiveAccess(group: group) {
            try await function()
        }
    }
}

/// Actor that provides mutual exclusion for suite execution.
///
/// Uses a keyed semaphore pattern: suites with the same group key
/// are mutually exclusive.
private actor ExclusionController {
    static let shared = ExclusionController()

    /// Tracks which groups are currently running.
    private var runningGroups: Set<String> = []

    /// Continuations waiting for access, keyed by group.
    private var waiters: [String: [CheckedContinuation<Void, Never>]] = [:]

    func withExclusiveAccess<T: Sendable>(
        group: String,
        _ operation: @Sendable () async throws -> T
    ) async rethrows -> T {
        // Wait until we can acquire the lock for this group
        while runningGroups.contains(group) {
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                waiters[group, default: []].append(continuation)
            }
        }

        // Acquire lock
        runningGroups.insert(group)

        do {
            let result = try await operation()
            release(group: group)
            return result
        } catch {
            release(group: group)
            throw error
        }
    }

    private func release(group: String) {
        runningGroups.remove(group)

        // Resume one waiter for this group
        if var groupWaiters = waiters[group], !groupWaiters.isEmpty {
            let next = groupWaiters.removeFirst()
            if groupWaiters.isEmpty {
                waiters.removeValue(forKey: group)
            } else {
                waiters[group] = groupWaiters
            }
            next.resume()
        }
    }
}

extension Trait where Self == Exclusive {
    /// Provides mutual exclusion with all other ungrouped suites globally.
    ///
    /// Suites using `.exclusive` will not overlap with each other,
    /// but their execution order is not guaranteed.
    public static var exclusive: Self { Exclusive() }

    /// Provides mutual exclusion within a specific group.
    ///
    /// Suites with the same group will not overlap with each other.
    /// Suites in different groups can run in parallel.
    ///
    /// - Parameter group: A string identifier for the exclusion group.
    ///   Use a fully-qualified name (e.g., "ModuleName.TypeName") to avoid collisions.
    public static func exclusive(group: String) -> Self {
        Exclusive(group: group)
    }
}
