// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-standards open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-standards project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension Heap {
    /// Internal node representation for min-max heap navigation.
    ///
    /// Tracks both the array offset and the tree level for efficient
    /// level-aware operations.
    @usableFromInline
    struct Node {
        @usableFromInline
        var offset: Int

        @usableFromInline
        var level: Int

        @inlinable
        init(offset: Int, level: Int) {
            self.offset = offset
            self.level = level
        }

        @inlinable
        init(offset: Int) {
            self.init(offset: offset, level: Self.level(forOffset: offset))
        }
    }
}

// MARK: - Comparable

extension Heap.Node: Comparable {
    @inlinable
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.offset == rhs.offset
    }

    @inlinable
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.offset < rhs.offset
    }
}

// MARK: - Level Calculations

extension Heap.Node {
    /// Computes the level for a given offset.
    /// Level = floor(log2(offset + 1))
    @inlinable
    static func level(forOffset offset: Int) -> Int {
        (offset &+ 1)._binaryLogarithm()
    }

    /// Whether a level is a min level (even: 0, 2, 4, ...).
    @inlinable
    static func isMinLevel(_ level: Int) -> Bool {
        level & 0b1 == 0
    }

    /// Whether this node is on a min level.
    @inlinable
    var isMinLevel: Bool {
        Self.isMinLevel(level)
    }

    /// Whether this is the root node.
    @inlinable
    var isRoot: Bool {
        offset == 0
    }
}

// MARK: - Well-Known Nodes

extension Heap.Node {
    /// The root node (index 0, level 0).
    @inlinable
    static var root: Self {
        Self(offset: 0, level: 0)
    }

    /// The left child of root (index 1, level 1).
    @inlinable
    static var leftMax: Self {
        Self(offset: 1, level: 1)
    }

    /// The right child of root (index 2, level 1).
    @inlinable
    static var rightMax: Self {
        Self(offset: 2, level: 1)
    }

    /// First node on the given level.
    @inlinable
    static func firstNode(onLevel level: Int) -> Self {
        Self(offset: (1 &<< level) &- 1, level: level)
    }

    /// Last node on the given level.
    @inlinable
    static func lastNode(onLevel level: Int) -> Self {
        Self(offset: (1 &<< (level &+ 1)) &- 2, level: level)
    }
}

// MARK: - Navigation

extension Heap.Node {
    /// Returns the parent node.
    ///
    /// - Precondition: This is not the root.
    @inlinable
    func parent() -> Self {
        Self(offset: (offset &- 1) / 2, level: level &- 1)
    }

    /// Returns the grandparent node, if any.
    @inlinable
    func grandParent() -> Self? {
        guard offset > 2 else { return nil }
        return Self(offset: (offset &- 3) / 4, level: level &- 2)
    }

    /// Returns the left child node.
    @inlinable
    func leftChild() -> Self {
        Self(offset: offset &* 2 &+ 1, level: level &+ 1)
    }

    /// Returns the right child node.
    @inlinable
    func rightChild() -> Self {
        Self(offset: offset &* 2 &+ 2, level: level &+ 1)
    }

    /// Returns the first grandchild node.
    @inlinable
    func firstGrandchild() -> Self {
        Self(offset: offset &* 4 &+ 3, level: level &+ 2)
    }

    /// Returns the last grandchild node.
    @inlinable
    func lastGrandchild() -> Self {
        Self(offset: offset &* 4 &+ 6, level: level &+ 2)
    }
}

// MARK: - Range Operations

extension Heap.Node {
    /// Returns the range of nodes on a level up to a limit.
    @inlinable
    static func allNodes(onLevel level: Int, limit: Int) -> ClosedRange<Self>? {
        let first = Self.firstNode(onLevel: level)
        guard first.offset < limit else { return nil }
        var last = Self.lastNode(onLevel: level)
        if last.offset >= limit {
            last.offset = limit &- 1
        }
        return first...last
    }
}

// MARK: - Binary Logarithm

extension Int {
    /// Computes floor(log2(self)).
    ///
    /// - Precondition: self > 0
    @usableFromInline
    func _binaryLogarithm() -> Int {
        precondition(self > 0)
        return Int.bitWidth - 1 - self.leadingZeroBitCount
    }
}
