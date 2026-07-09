import StandardsTestSupport
import Testing

@testable import StandardLibraryExtensions

// MARK: - Performance Tests

extension `Performance Tests` {
    @Suite
    struct `Set - Performance` {

        @Test(.timed(threshold: .milliseconds(15), maxAllocations: 10_000_000))
        func `partition 10k elements`() {
            let numbers: Set = Set(1...10_000)
            _ = numbers.partition(where: { $0.isMultiple(of: 2) })
        }

        @Test(.timed(threshold: .milliseconds(2), maxAllocations: 2_000_000))
        func `subsets of size 2 from 20 elements`() {
            let set: Set = Set(1...20)
            _ = set.subsets(ofSize: 2)
        }

        @Test(.timed(threshold: .milliseconds(100), maxAllocations: 2_000_000))
        func `subsets of size 5 from 15 elements`() {
            let set: Set = Set(1...15)
            _ = set.subsets(ofSize: 5)
        }

        @Test(.timed(threshold: .milliseconds(50), maxAllocations: 500_000))
        func `cartesianProduct 100x100`() {
            let a: Set = Set(1...100)
            let b: Set = Set(1...100)
            _ = a.cartesianProduct(b)
        }

        @Test(.timed(threshold: .milliseconds(20), maxAllocations: 2_000_000))
        func `cartesianSquare 100 elements`() {
            let set: Set = Set(1...100)
            _ = set.cartesianSquare()
        }
    }
}
