// swift-tools-version: 6.2

import CompilerPluginSupport
import PackageDescription

// Swift Embedded compatible:
// - No Foundation dependencies
// - No existential types (any Protocol)
// - No reflection or runtime features
// - Pure Swift value types only

let package = Package(
    name: "swift-standards",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        // Umbrella product - includes all modules
        .library(
            name: "Standards",
            targets: [
                "Standards",
                "StandardLibraryExtensions",
                "Formatting",
                "StandardTime",
                "Locale",
                "Algebra",
                "Algebra Linear",
                "Affine",
                "Binary",
                "Dimension",
                "Positioning",
                "Symmetry",
                "Region",
                "Geometry",
                "Layout",
                "TernaryLogic",
                "Predicate",
                "Parsing",
            ]
        ),
        // Individual modules
        .library(
            name: "StandardLibraryExtensions",
            targets: ["StandardLibraryExtensions"]
        ),
        .library(
            name: "Formatting",
            targets: ["Formatting"]
        ),
        .library(
            name: "StandardTime",
            targets: ["StandardTime"]
        ),
        .library(
            name: "Locale",
            targets: ["Locale"]
        ),
        .library(
            name: "Algebra",
            targets: ["Algebra"]
        ),
        .library(
            name: "Algebra Linear",
            targets: ["Algebra Linear"]
        ),
        .library(
            name: "Affine",
            targets: ["Affine"]
        ),
        .library(
            name: "Binary",
            targets: ["Binary"]
        ),
        .library(
            name: "Dimension",
            targets: ["Dimension"]
        ),
        .library(
            name: "Positioning",
            targets: ["Positioning"]
        ),
        .library(
            name: "Symmetry",
            targets: ["Symmetry"]
        ),
        .library(
            name: "Region",
            targets: ["Region"]
        ),
        .library(
            name: "Geometry",
            targets: ["Geometry"]
        ),
        .library(
            name: "Layout",
            targets: ["Layout"]
        ),
        .library(
            name: "StandardsTestSupport",
            targets: ["StandardsTestSupport"]
        ),
        .library(
            name: "TernaryLogic",
            targets: ["TernaryLogic"]
        ),
        .library(
            name: "Predicate",
            targets: ["Predicate"]
        ),
        .library(
            name: "Parsing",
            targets: ["Parsing"]
        ),
    ],
    traits: [
        .trait(
            name: "Codable",
            description: "Include Codable conformances (not compatible with Swift Embedded)"
        )
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-testing-performance", from: "0.3.1"),
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax", "600.0.0"..<"603.0.0"),
    ],
    targets: [
        .target(
            name: "Standards",
            dependencies: [
                "StandardLibraryExtensions",
                "Formatting",
                "StandardTime",
                "Locale",
                "Algebra",
                "Algebra Linear",
                "Affine",
                "Binary",
                "Dimension",
                "Positioning",
                "Symmetry",
                "Region",
                "Geometry",
                "Layout",
                "TernaryLogic",
                "Predicate",
                "Parsing",
            ]
        ),
        .target(
            name: "StandardLibraryExtensions"
        ),
        .target(
            name: "Formatting",
            dependencies: [
                "StandardLibraryExtensions"
            ]
        ),
        .target(
            name: "StandardTime",
            dependencies: [
                "StandardLibraryExtensions",
                "Dimension"
            ]
        ),
        .target(
            name: "Locale",
            dependencies: [
                "StandardLibraryExtensions"
            ]
        ),
        .target(
            name: "Algebra",
            dependencies: [
                "Dimension"
            ]
        ),
        .target(
            name: "Algebra Linear",
            dependencies: [
                "Algebra",
                "Dimension",
                "Formatting",
                .product(name: "RealModule", package: "swift-numerics"),
            ]
        ),
        .target(
            name: "Affine",
            dependencies: [
                "Algebra Linear",
                "Formatting",
                .product(name: "RealModule", package: "swift-numerics"),
            ]
        ),
        .target(
            name: "Binary",
            dependencies: [
                "Algebra",
                "Formatting",
                "Parsing"
            ]
        ),
        .target(
            name: "Dimension",
            dependencies: [
                "Formatting",
                .product(name: "RealModule", package: "swift-numerics"),
            ]
        ),
        .target(
            name: "Positioning"
        ),
        .target(
            name: "Region",
            dependencies: [
                "Dimension",
                "Algebra",
            ]
        ),
        .target(
            name: "Geometry",
            dependencies: [
                "Algebra",
                "Algebra Linear",
                "Affine",
                "Dimension",
                "Formatting",
                "Region",
                .product(name: "RealModule", package: "swift-numerics"),
            ]
        ),
        .target(
            name: "Symmetry",
            dependencies: [
                "Algebra Linear",
                "Affine",
                "Geometry",
            ]
        ),
        .target(
            name: "Layout",
            dependencies: [
                "Dimension",
                "Positioning",
                "Geometry",
            ]
        ),
        .target(
            name: "TernaryLogic",
            dependencies: [
                "StandardLibraryExtensions"
            ]
        ),
        .target(
            name: "Predicate",
            dependencies: [
                "TernaryLogic"
            ]
        ),
        .target(
            name: "Parsing",
            dependencies: []
        ),
        .macro(
            name: "StandardsTestSupportMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "StandardsTestSupport",
            dependencies: [
                "StandardsTestSupportMacros",
                .product(name: "TestingPerformance", package: "swift-testing-performance"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "StandardLibraryExtensions".tests,
            dependencies: [
                "StandardLibraryExtensions",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Formatting".tests,
            dependencies: [
                "Formatting",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "StandardTime".tests,
            dependencies: [
                "StandardTime",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Locale".tests,
            dependencies: [
                "Locale",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Algebra".tests,
            dependencies: [
                "Algebra",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Algebra Linear".tests,
            dependencies: [
                "Algebra Linear",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Affine".tests,
            dependencies: [
                "Affine",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Binary".tests,
            dependencies: [
                "Binary",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Dimension".tests,
            dependencies: [
                "Dimension",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Positioning".tests,
            dependencies: [
                "Positioning",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Symmetry".tests,
            dependencies: [
                "Algebra Linear",
                "Symmetry",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Region".tests,
            dependencies: [
                "Region",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Geometry".tests,
            dependencies: [
                "Affine",
                "Algebra Linear",
                "Geometry",
                "Symmetry",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Layout".tests,
            dependencies: [
                "Layout",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "TernaryLogic".tests,
            dependencies: [
                "TernaryLogic",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "Predicate".tests,
            dependencies: [
                "Predicate",
                "StandardsTestSupport",
            ]
        ),
        .testTarget(
            name: "StandardsTestSupport".tests,
            dependencies: [
                "StandardsTestSupport",
                "StandardsTestSupportMacros",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "Parsing".tests,
            dependencies: [
                "Parsing",
                "StandardsTestSupport",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
    var foundation: Self { self + " Foundation" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings =
        existing + [
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableExperimentalFeature("Lifetimes"),
        ]
}
