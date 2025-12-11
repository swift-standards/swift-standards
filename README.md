# swift-standards

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The foundational library for the [Swift Standards](https://github.com/swift-standards) organization. Type-safe primitives for geometry, algebra, time, binary operations, and more. Swift 6 strict concurrency. Swift Embedded compatible.

## Table of Contents

- [Overview](#overview)
- [Why](#why)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Core Concepts](#core-concepts)
- [Modules](#modules)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Platform Support](#platform-support)
- [Related Packages](#related-packages)
- [Contributing](#contributing)
- [License](#license)

## Overview

swift-standards provides the shared foundation upon which all [Swift Standards](https://github.com/swift-standards) packages are built. It delivers types that catch errors at compile time rather than runtime, distinguishing between concepts that look similar but behave differently: coordinates vs displacements, points vs vectors, angles vs scalars.

No Foundation dependency. Pure Swift value types optimized for Swift Embedded and high-performance applications.

## Why

**Rules deserve to be written in a form that leaves no ambiguity.**

The [Swift Standards](https://github.com/swift-standards) organization implements international technical standards as executable Swift code. Rather than interpreting specification documents, we encode them as precise, compiler-enforced types. Invalid states become unrepresentable.

This package provides the primitives that make that possible:

- **Phantom types** distinguish values that share the same representation but have different meanings
- **Algebraic structure** encodes mathematical rules (you can't add two points, but you can add two vectors)
- **Zero-cost abstractions** ensure type safety without runtime overhead

When a specification says "a rectangle has width and height", this library ensures width and height are distinct types - not just two `Double` values that could be accidentally swapped.

## Features

- Type-safe geometry with compile-time distinction between coordinates and displacements
- Phantom types via `Tagged<Tag, RawValue>` for zero-cost type safety
- Mathematical precision: affine space (points) vs linear space (vectors)
- Composable predicates with Boolean algebra properties
- Three-valued logic for SQL-style NULL handling
- Standard library extensions without Foundation
- Binary serialization with endianness control
- Calendar operations independent of Foundation
- Swift 6 strict concurrency with Sendable throughout
- 1,600+ tests covering edge cases and mathematical properties

## Installation

Add swift-standards to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/swift-standards/swift-standards.git", from: "0.1.0")
]
```

Add the umbrella product or individual modules:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        // Umbrella - includes all modules
        .product(name: "Standards", package: "swift-standards")

        // Or individual modules
        .product(name: "Geometry", package: "swift-standards"),
        .product(name: "Predicate", package: "swift-standards"),
    ]
)
```

### Requirements

- Swift 6.2+
- macOS 26.0+ / iOS 26.0+ / watchOS 26.0+ / tvOS 26.0+ / visionOS 26.0+ / Linux

## Quick Start

### Type-Safe Geometry

```swift
import Geometry

// Points are positions in space
let origin: Geometry<Double>.Point<2> = .zero
let target: Geometry<Double>.Point<2> = .init(x: 10, y: 20)

// Vectors are displacements between points
let displacement = target - origin  // Vector<2>

// Point + Vector = Point (moving a point)
let newPoint = origin + displacement

// Point - Point = Vector (displacement between points)
// Point + Point = Compile Error (meaningless operation)
```

### Composable Predicates

```swift
import Predicate

// Build predicates from simple conditions
let isEven = Predicate<Int> { $0 % 2 == 0 }
let isPositive = Predicate<Int> { $0 > 0 }

// Compose with operators
let isEvenAndPositive = isEven && isPositive
let isOdd = !isEven

// Fluent factory methods
let isAdult = Predicate<Int>.greater.thanOrEqualTo(18)
let isInRange = Predicate<Int>.in.range(1...100)
let hasPrefix = Predicate<String>.has.prefix("swift-")

// Predicates are callable
isEven(4)           // true
isEvenAndPositive(4) // true
isEvenAndPositive(-4) // false
```

### Tagged Values (Phantom Types)

```swift
import Dimension

// Define phantom types for different domains
enum UserIDTag {}
enum OrderIDTag {}

typealias UserID = Tagged<UserIDTag, Int>
typealias OrderID = Tagged<OrderIDTag, Int>

let userId: UserID = Tagged(42)
let orderId: OrderID = Tagged(42)

// Same underlying value, but different types
// userId == orderId  // Compile error: cannot compare UserID with OrderID

func fetchUser(id: UserID) -> User { ... }
fetchUser(id: orderId)  // Compile error: expected UserID, got OrderID
```

## Core Concepts

### Coordinates vs Displacements

The type system distinguishes between positions (coordinates) and directed extents (displacements):

```swift
// Coordinates: positions in space (X, Y, Z)
let x: Geometry<Double>.X = 10  // An x-coordinate
let y: Geometry<Double>.Y = 20  // A y-coordinate

// Displacements: directed changes (Width, Height, Depth)
let width: Geometry<Double>.Width = 5   // A horizontal displacement
let height: Geometry<Double>.Height = 3  // A vertical displacement

// Coordinate + Displacement = Coordinate
let newX = x + width  // X coordinate

// Coordinate - Coordinate = Displacement
let diff = x - Geometry<Double>.X(5)  // Width displacement

// Displacement + Displacement = Displacement
let totalWidth = width + Geometry<Double>.Width(10)
```

This prevents common bugs like accidentally adding two positions or treating a displacement as a position.

### Affine vs Linear Space

Points live in affine space. Vectors live in linear space. The operations available reflect this mathematical structure:

```swift
import Affine
import Algebra_Linear

// Points (affine space) - no addition, no scaling
let p1: Affine<Double>.Point<2> = .init(x: 0, y: 0)
let p2: Affine<Double>.Point<2> = .init(x: 10, y: 10)

// Vectors (linear space) - support addition and scaling
let v1: Linear<Double>.Vector<2> = .init(dx: 1, dy: 0)
let v2: Linear<Double>.Vector<2> = .init(dx: 0, dy: 1)

let sum = v1 + v2           // Vector addition
let scaled = v1 * 2.0       // Scalar multiplication
let displacement = p2 - p1  // Point difference yields vector
let moved = p1 + v1         // Point + Vector = Point
```

### Zero-Cost Abstractions

`Tagged<Tag, RawValue>` wraps values with phantom types that exist only at compile time:

```swift
// The tag is purely a compile-time marker
public struct Tagged<Tag, RawValue> {
    public var rawValue: RawValue
}

// Geometry.X is just Tagged<Index.X.Coordinate, Scalar>
// No runtime overhead - same memory layout as the raw value
```

## Modules

| Module | Purpose |
|--------|---------|
| **Standards** | Umbrella module including all below |
| **Geometry** | Points, vectors, rectangles, circles, ellipses, arcs, beziers, polygons |
| **Affine** | Affine space: points, transforms (translation, rotation, scaling) |
| **Algebra Linear** | Linear space: vectors, matrices, linear transforms |
| **Algebra** | Algebraic structures and protocols |
| **Dimension** | Phantom types: `Tagged`, axis types, orientations (horizontal, vertical, depth) |
| **Angle** | `Radian` and `Degree` with trigonometric functions |
| **Predicate** | Composable boolean predicates with Boolean algebra |
| **TernaryLogic** | Three-valued logic (true, false, unknown) for SQL-style semantics |
| **Binary** | Byte serialization, endianness, bit manipulation |
| **StandardTime** | Calendar operations without Foundation |
| **Locale** | Locale handling without Foundation |
| **Formatting** | Number and value formatting |
| **Positioning** | Layout distribution types |
| **Layout** | Grid, stack, and flow layouts |
| **Region** | Bounded regions and intervals |
| **Symmetry** | Geometric symmetry operations |
| **StandardLibraryExtensions** | Extensions to Swift standard library types |

## Usage Examples

### Geometry

```swift
import Geometry

// Rectangle from corners
let rect = Geometry<Double>.Rectangle(
    llx: 0, lly: 0,  // lower-left
    urx: 100, ury: 50 // upper-right
)
print(rect.width)   // 100
print(rect.height)  // 50
print(rect.center)  // Point(x: 50, y: 25)

// Circle
let circle = Geometry<Double>.Circle(
    center: .init(x: 0, y: 0),
    radius: 10
)
print(circle.area)          // ~314.16
print(circle.circumference) // ~62.83
print(circle.contains(.init(x: 5, y: 5)))  // true

// Bezier curves
let bezier = Geometry<Double>.Bezier.quadratic(
    from: .init(x: 0, y: 0),
    control: .init(x: 50, y: 100),
    to: .init(x: 100, y: 0)
)
let midpoint = bezier.point(at: 0.5)
```

### Transforms

```swift
import Affine

let point: Affine<Double>.Point<2> = .init(x: 10, y: 0)

// Fluent transform API
let transform = Affine<Double>.Transform.identity
    .translated(by: .init(dx: 5, dy: 5))
    .rotated(by: .halfPi)  // 90 degrees
    .scaled(by: 2)

let transformed = transform.apply(to: point)
```

### Three-Valued Logic

```swift
import TernaryLogic

// For SQL-style NULL handling
let a: Ternary = .true
let b: Ternary = .unknown
let c: Ternary = .false

a && b  // .unknown (true AND unknown = unknown)
a || b  // .true (true OR unknown = true)
b && c  // .false (unknown AND false = false)
!b      // .unknown (NOT unknown = unknown)
```

### Binary Operations

```swift
import Binary

// Byte serialization with endianness control
let value: UInt32 = 0x12345678

let littleEndian = value.bytes(.littleEndian)  // [0x78, 0x56, 0x34, 0x12]
let bigEndian = value.bytes(.bigEndian)        // [0x12, 0x34, 0x56, 0x78]

// Bit manipulation
let rotated = value.rotateLeft(by: 8)
let reversed = value.reverseBits
```

### Standard Library Extensions

```swift
import StandardLibraryExtensions

// Safe collection access
let array = [1, 2, 3]
array[safe: 5]  // nil instead of crash

// Result builders for collections
let numbers = Array.build {
    1
    2
    if condition { 3 }
    for i in 4...6 { i }
}

// String utilities
"  hello  ".trimmed()  // "hello"
"hello world".range(of: "world")  // Range<String.Index>?
```

## Testing

```bash
# All tests (1,600+)
swift test

# Specific module
swift test --filter Geometry

# With verbose output
swift test --verbose
```

## Platform Support

| Platform | Status |
|----------|--------|
| macOS | Full support |
| iOS | Full support |
| watchOS | Full support |
| tvOS | Full support |
| visionOS | Full support |
| Linux | Full support |
| Swift Embedded | Compatible |

No Foundation dependency. Pure Swift value types only.

### Swift Embedded

By default, the package is Swift Embedded compatible. To enable `Codable` conformances (which use `any` existentials not supported in Embedded), add the `Codable` trait:

```swift
.product(name: "Standards", package: "swift-standards", traits: ["Codable"])
```

## Related Packages

### Swift Standards Organization

This package is the foundation for the [Swift Standards](https://github.com/swift-standards) organization, which implements international technical standards as executable Swift code. Other packages in the organization include implementations of RFC specifications, web standards (WHATWG URL), document formats (PDF, SVG), and more.

### Dependencies

- [apple/swift-numerics](https://github.com/apple/swift-numerics): Real and complex number support

### By the Same Author

- [swift-html-to-pdf](https://github.com/coenttb/swift-html-to-pdf): HTML to PDF conversion with actor-based resource pooling
- [swift-html](https://github.com/coenttb/swift-html): Type-safe HTML and CSS DSL
- [swift-resource-pool](https://github.com/coenttb/swift-resource-pool): Actor-based resource pooling

## Contributing

Contributions welcome. Please:

1. Add tests - comprehensive coverage maintained
2. Follow conventions - Swift 6, strict concurrency, no force-unwraps
3. Document public APIs - DocC comments with examples

Areas for contribution:
- Additional geometric primitives
- Performance optimizations
- Documentation and examples

## License

Apache 2.0 - See [LICENSE](LICENSE.md) for details.
