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
    /// Internal storage for the min-max heap.
    @usableFromInline
    struct Storage {
        @usableFromInline
        var elements: ContiguousArray<Element>

        @inlinable
        init() {
            self.elements = []
        }

        @inlinable
        init(_ sequence: some Sequence<Element>) {
            self.elements = ContiguousArray(sequence)
            guard elements.count > 1 else { return }
            heapify()
        }
    }
}

// MARK: - Properties

extension Heap.Storage {
    @inlinable
    var count: Int { elements.count }

    @inlinable
    var isEmpty: Bool { elements.isEmpty }
}

// MARK: - Capacity

extension Heap.Storage {
    @inlinable
    mutating func reserveCapacity(_ minimumCapacity: Int) {
        elements.reserveCapacity(minimumCapacity)
    }

    @inlinable
    mutating func removeAll(keepingCapacity: Bool) {
        elements.removeAll(keepingCapacity: keepingCapacity)
    }
}

// MARK: - Peek

extension Heap.Storage {
    /// Returns the minimum element (at root).
    @inlinable
    func peekMin() -> Element? {
        elements.first
    }

    /// Returns the maximum element.
    ///
    /// - If count <= 2, max is the last element
    /// - Otherwise, max is the larger of indices 1 and 2
    @inlinable
    func peekMax() -> Element? {
        guard count > 2 else { return elements.last }
        return Swift.max(elements[1], elements[2])
    }

    /// Returns the index of the maximum element.
    @inlinable
    func maxIndex() -> Int? {
        switch count {
        case 0: return nil
        case 1: return 0
        case 2: return 1
        default: return elements[1] >= elements[2] ? 1 : 2
        }
    }
}

// MARK: - Insert

extension Heap.Storage {
    /// Inserts an element and restores heap property.
    @inlinable
    mutating func insert(_ element: Element) {
        elements.append(element)
        bubbleUp(Heap.Node(offset: count - 1))
    }

    /// Inserts multiple elements using heuristic for efficiency.
    @inlinable
    mutating func insert(contentsOf newElements: some Sequence<Element>) {
        let origCount = count
        elements.append(contentsOf: newElements)
        let newCount = count

        guard newCount > origCount, newCount > 1 else { return }

        // Heuristic: use Floyd's if k > 2n / log(n)
        let heuristicLimit = 2 * newCount / Swift.max(1, newCount._binaryLogarithm())
        let useFloyd = (newCount - origCount) > heuristicLimit

        if useFloyd {
            heapify()
        } else {
            for offset in origCount ..< newCount {
                bubbleUp(Heap.Node(offset: offset))
            }
        }
    }
}

// MARK: - Remove

extension Heap.Storage {
    /// Removes and returns the minimum element.
    @inlinable
    mutating func removeMin() -> Element? {
        guard !isEmpty else { return nil }

        var removed = elements.removeLast()
        guard !isEmpty else { return removed }

        swap(&elements[0], &removed)
        trickleDownMin(Heap.Node.root)
        return removed
    }

    /// Removes and returns the maximum element.
    @inlinable
    mutating func removeMax() -> Element? {
        guard !isEmpty else { return nil }
        guard count > 2 else { return elements.popLast() }

        var removed = elements.removeLast()

        if count == 2 {
            if elements[1] > removed {
                swap(&elements[1], &removed)
            }
        } else {
            let maxNode = elements[1] >= elements[2] ? Heap.Node.leftMax : Heap.Node.rightMax
            swap(&elements[maxNode.offset], &removed)
            trickleDownMax(maxNode)
        }

        return removed
    }
}

// MARK: - Replace

extension Heap.Storage {
    /// Replaces the minimum and returns the old value.
    @inlinable
    mutating func replaceMin(with replacement: Element) -> Element {
        var removed = replacement
        swap(&elements[0], &removed)
        trickleDownMin(Heap.Node.root)
        return removed
    }

    /// Replaces the maximum and returns the old value.
    @inlinable
    mutating func replaceMax(with replacement: Element) -> Element {
        var removed = replacement

        switch count {
        case 1:
            swap(&elements[0], &removed)
        case 2:
            swap(&elements[1], &removed)
            bubbleUp(Heap.Node.leftMax)
        default:
            let maxNode = elements[1] >= elements[2] ? Heap.Node.leftMax : Heap.Node.rightMax
            swap(&elements[maxNode.offset], &removed)
            bubbleUp(maxNode)
            trickleDownMax(maxNode)
        }

        return removed
    }
}

// MARK: - Bubble Up

extension Heap.Storage {
    /// Restores heap property by moving element up.
    @inlinable
    mutating func bubbleUp(_ node: Heap.Node) {
        guard !node.isRoot else { return }

        let parent = node.parent()
        var node = node

        if (node.isMinLevel && elements[node.offset] > elements[parent.offset])
            || (!node.isMinLevel && elements[node.offset] < elements[parent.offset]) {
            elements.swapAt(node.offset, parent.offset)
            node = parent
        }

        if node.isMinLevel {
            while let grandparent = node.grandParent(),
                  elements[node.offset] < elements[grandparent.offset] {
                elements.swapAt(node.offset, grandparent.offset)
                node = grandparent
            }
        } else {
            while let grandparent = node.grandParent(),
                  elements[node.offset] > elements[grandparent.offset] {
                elements.swapAt(node.offset, grandparent.offset)
                node = grandparent
            }
        }
    }
}

// MARK: - Trickle Down Min

extension Heap.Storage {
    /// Sinks element at min-level node to correct position.
    @inlinable
    mutating func trickleDownMin(_ node: Heap.Node) {
        var node = node
        var value = elements[node.offset]

        var gc0 = node.firstGrandchild()
        while gc0.offset &+ 3 < count {
            // Four grandchildren - find minimum
            let gc1 = Heap.Node(offset: gc0.offset &+ 1, level: gc0.level)
            let gc2 = Heap.Node(offset: gc0.offset &+ 2, level: gc0.level)
            let gc3 = Heap.Node(offset: gc0.offset &+ 3, level: gc0.level)

            let minA = minNode(gc0, gc1)
            let minB = minNode(gc2, gc3)
            let minGC = minNode(minA, minB)

            guard elements[minGC.offset] < value else {
                elements[node.offset] = value
                return
            }

            elements[node.offset] = elements[minGC.offset]
            node = minGC
            gc0 = node.firstGrandchild()

            let parent = minGC.parent()
            if elements[parent.offset] < value {
                swap(&elements[parent.offset], &value)
            }
        }

        // Handle remaining children/grandchildren
        let c0 = node.leftChild()
        if c0.offset >= count {
            elements[node.offset] = value
            return
        }

        let minDesc = minDescendant(c0: c0, gc0: gc0)
        guard elements[minDesc.offset] < value else {
            elements[node.offset] = value
            return
        }

        elements[node.offset] = elements[minDesc.offset]
        node = minDesc

        if minDesc >= gc0 {
            let parent = minDesc.parent()
            if elements[parent.offset] < value {
                elements[node.offset] = elements[parent.offset]
                node = parent
            }
        }

        elements[node.offset] = value
    }

    @inlinable
    func minNode(_ a: Heap.Node, _ b: Heap.Node) -> Heap.Node {
        elements[b.offset] < elements[a.offset] ? b : a
    }

    @inlinable
    func minDescendant(c0: Heap.Node, gc0: Heap.Node) -> Heap.Node {
        let c1 = Heap.Node(offset: c0.offset &+ 1, level: c0.level)

        if gc0.offset < count {
            if gc0.offset &+ 2 < count {
                let gc1 = Heap.Node(offset: gc0.offset &+ 1, level: gc0.level)
                let gc2 = Heap.Node(offset: gc0.offset &+ 2, level: gc0.level)
                return minNode(minNode(gc0, gc1), gc2)
            }

            let m = minNode(c1, gc0)
            if gc0.offset &+ 1 < count {
                let gc1 = Heap.Node(offset: gc0.offset &+ 1, level: gc0.level)
                return minNode(m, gc1)
            }
            return m
        }

        if c1.offset < count {
            return minNode(c0, c1)
        }
        return c0
    }
}

// MARK: - Trickle Down Max

extension Heap.Storage {
    /// Sinks element at max-level node to correct position.
    @inlinable
    mutating func trickleDownMax(_ node: Heap.Node) {
        var node = node
        var value = elements[node.offset]

        var gc0 = node.firstGrandchild()
        while gc0.offset &+ 3 < count {
            // Four grandchildren - find maximum
            let gc1 = Heap.Node(offset: gc0.offset &+ 1, level: gc0.level)
            let gc2 = Heap.Node(offset: gc0.offset &+ 2, level: gc0.level)
            let gc3 = Heap.Node(offset: gc0.offset &+ 3, level: gc0.level)

            let maxA = maxNode(gc0, gc1)
            let maxB = maxNode(gc2, gc3)
            let maxGC = maxNode(maxA, maxB)

            guard value < elements[maxGC.offset] else {
                elements[node.offset] = value
                return
            }

            elements[node.offset] = elements[maxGC.offset]
            node = maxGC
            gc0 = node.firstGrandchild()

            let parent = maxGC.parent()
            if value < elements[parent.offset] {
                swap(&elements[parent.offset], &value)
            }
        }

        // Handle remaining children/grandchildren
        let c0 = node.leftChild()
        if c0.offset >= count {
            elements[node.offset] = value
            return
        }

        let maxDesc = maxDescendant(c0: c0, gc0: gc0)
        guard value < elements[maxDesc.offset] else {
            elements[node.offset] = value
            return
        }

        elements[node.offset] = elements[maxDesc.offset]
        node = maxDesc

        if maxDesc >= gc0 {
            let parent = maxDesc.parent()
            if value < elements[parent.offset] {
                elements[node.offset] = elements[parent.offset]
                node = parent
            }
        }

        elements[node.offset] = value
    }

    @inlinable
    func maxNode(_ a: Heap.Node, _ b: Heap.Node) -> Heap.Node {
        elements[b.offset] >= elements[a.offset] ? b : a
    }

    @inlinable
    func maxDescendant(c0: Heap.Node, gc0: Heap.Node) -> Heap.Node {
        let c1 = Heap.Node(offset: c0.offset &+ 1, level: c0.level)

        if gc0.offset < count {
            if gc0.offset &+ 2 < count {
                let gc1 = Heap.Node(offset: gc0.offset &+ 1, level: gc0.level)
                let gc2 = Heap.Node(offset: gc0.offset &+ 2, level: gc0.level)
                return maxNode(maxNode(gc0, gc1), gc2)
            }

            let m = maxNode(c1, gc0)
            if gc0.offset &+ 1 < count {
                let gc1 = Heap.Node(offset: gc0.offset &+ 1, level: gc0.level)
                return maxNode(m, gc1)
            }
            return m
        }

        if c1.offset < count {
            return maxNode(c0, c1)
        }
        return c0
    }
}

// MARK: - Heapify (Floyd's Algorithm)

extension Heap.Storage {
    /// Converts storage to valid min-max heap in O(n).
    @inlinable
    mutating func heapify() {
        let limit = count / 2
        var level = Heap.Node.level(forOffset: limit &- 1)

        while level >= 0 {
            if let nodes = Heap.Node.allNodes(onLevel: level, limit: limit) {
                if Heap.Node.isMinLevel(level) {
                    for offset in nodes.lowerBound.offset ... nodes.upperBound.offset {
                        trickleDownMin(Heap.Node(offset: offset, level: level))
                    }
                } else {
                    for offset in nodes.lowerBound.offset ... nodes.upperBound.offset {
                        trickleDownMax(Heap.Node(offset: offset, level: level))
                    }
                }
            }
            level &-= 1
        }
    }
}

// MARK: - Sendable

extension Heap.Storage: Sendable where Element: Sendable {}
