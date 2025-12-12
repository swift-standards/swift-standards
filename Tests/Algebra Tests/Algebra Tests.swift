import StandardsTestSupport
import Testing

@testable import Algebra

// MARK: - Bool XOR Tests

@Suite("Bool - XOR Operator")
struct BoolXORTests {
    @Test(arguments: [
        (false, false, false),
        (false, true, true),
        (true, false, true),
        (true, true, false),
    ])
    func `xor operator is correct`(lhs: Bool, rhs: Bool, expected: Bool) {
        #expect((lhs ^ rhs) == expected)
    }

    @Test
    func `xor is exclusive or`() {
        #expect((true ^ false) == true)
        #expect((true ^ true) == false)
        #expect((false ^ false) == false)
        #expect((false ^ true) == true)
    }
}

// MARK: - Product Tests

@Suite("Product - Creation")
struct Product_CreationTests {
    @Test
    func `pair creation works`() {
        let pair = Product(1, "hello")
        #expect(pair.0 == 1)
        #expect(pair.1 == "hello")
    }

    @Test
    func `triple creation works`() {
        let triple = Product(1, "hello", true)
        #expect(triple.0 == 1)
        #expect(triple.1 == "hello")
        #expect(triple.2 == true)
    }

    @Test
    func `values tuple access works`() {
        let pair = Product(42, "test")
        #expect(pair.values.0 == 42)
        #expect(pair.values.1 == "test")
    }
}

@Suite("Product - Equatable")
struct Product_EquatableTests {
    @Test
    func `equal products compare equal`() {
        let p1 = Product(1, "hello")
        let p2 = Product(1, "hello")
        #expect(p1 == p2)
    }

    @Test
    func `unequal products compare unequal`() {
        let p1 = Product(1, "hello")
        let p2 = Product(1, "world")
        #expect(p1 != p2)
    }

    @Test
    func `different first values are unequal`() {
        let p1 = Product(1, "hello")
        let p2 = Product(2, "hello")
        #expect(p1 != p2)
    }
}

@Suite("Product - Hashable")
struct Product_HashableTests {
    @Test
    func `equal products have same hash`() {
        let p1 = Product(1, "hello")
        let p2 = Product(1, "hello")
        var hasher1 = Hasher()
        var hasher2 = Hasher()
        p1.hash(into: &hasher1)
        p2.hash(into: &hasher2)
        #expect(hasher1.finalize() == hasher2.finalize())
    }

    @Test
    func `product can be used in set`() {
        let p1 = Product(1, "hello")
        let p2 = Product(2, "world")
        let set: Set<Product<Int, String>> = [p1, p2]
        #expect(set.count == 2)
    }

    @Test
    func `product can be used as dictionary key`() {
        let p1 = Product(1, "hello")
        var dict: [Product<Int, String>: Int] = [:]
        dict[p1] = 42
        #expect(dict[p1] == 42)
    }
}

@Suite("Product - Sendable")
struct Product_SendableTests {
    @Test
    func `product is sendable`() {
        let p: Product<Int, String> = Product(1, "test")
        // If this compiles, Sendable conformance works
        let _: any Sendable = p
    }
}

// MARK: - Algebra Namespace

@Suite("Algebra - Namespace")
struct AlgebraNamespaceTests {
    @Test
    func `Algebra is enum`() {
        // Algebra is a namespace enum
        // This test primarily documents its existence
        let _: Algebra.Type = Algebra.self
    }
}
