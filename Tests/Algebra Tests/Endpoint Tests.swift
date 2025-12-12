import StandardsTestSupport
import Testing

@testable import Algebra

@Suite
struct `Endpoint - Static Functions` {
    @Test(arguments: Endpoint.allCases)
    func `opposite is involution`(endpoint: Endpoint) {
        #expect(Endpoint.opposite(of: Endpoint.opposite(of: endpoint)) == endpoint)
    }

    @Test
    func `opposite swaps values`() {
        #expect(Endpoint.opposite(of: .start) == .end)
        #expect(Endpoint.opposite(of: .end) == .start)
    }
}

@Suite
struct `Endpoint - Properties` {
    @Test
    func `cases exist`() {
        #expect(Endpoint.allCases.count == 2)
        #expect(Endpoint.allCases.contains(.start))
        #expect(Endpoint.allCases.contains(.end))
    }

    @Test(arguments: Endpoint.allCases)
    func `opposite property equals static function`(endpoint: Endpoint) {
        #expect(endpoint.opposite == Endpoint.opposite(of: endpoint))
    }

    @Test(arguments: Endpoint.allCases)
    func `negation operator works`(endpoint: Endpoint) {
        #expect(!endpoint == endpoint.opposite)
    }

    @Test
    func `aliases are correct`() {
        #expect(Endpoint.first == .start)
        #expect(Endpoint.last == .end)
        #expect(Endpoint.head == .start)
        #expect(Endpoint.tail == .end)
    }

    @Test
    func `Value typealias works`() {
        let paired: Endpoint.Value<String> = .init(.start, "begin")
        #expect(paired.first == .start)
        #expect(paired.second == "begin")
    }
}
