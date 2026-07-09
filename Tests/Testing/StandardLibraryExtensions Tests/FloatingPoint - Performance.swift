import StandardsTestSupport
import Testing

@testable import StandardLibraryExtensions

// MARK: - Performance Tests

extension `Performance Tests` {
    @Suite
    struct `FloatingPoint - Performance` {

        @Test(.timed(threshold: .milliseconds(75), maxAllocations: 2_000_000))
        func `isApproximatelyEqual 100k comparisons`() {
            let values = Array(0..<100_000).map { Double($0) + 0.1 }
            for (i, value) in values.enumerated() {
                _ = value.isApproximatelyEqual(to: Double(i), tolerance: 0.2)
            }
        }

        @Test(.timed(threshold: .milliseconds(60), maxAllocations: 2_000_000))
        func `lerp 100k interpolations`() {
            let values = Array(0..<100_000).map { Double($0) / 100_000.0 }
            for t in values {
                _ = 0.0.lerp(to: 100.0, t: t)
            }
        }

        @Test(.timed(threshold: .milliseconds(100), maxAllocations: 2_000_000))
        func `rounded 100k values`() {
            let values = Array(0..<100_000).map { Double($0) / 1000.0 }
            for value in values {
                _ = value.rounded(to: 2)
            }
        }
    }
}
