// swift-tools-version: 6.1

import PackageDescription

// Swift Embedded compatible:
// - No Foundation dependencies
// - No existential types (any Protocol)
// - No reflection or runtime features
// - Pure Swift value types only

let package = Package(
    name: "swift-standards",
    products: [
        .library(
            name: "Standards",
            targets: ["Standards"]
        ),
        .library(
            name: "StandardsTestSupport",
            targets: ["StandardsTestSupport"]
        )
    ],
    dependencies: [
        .package(path: "../../coenttb/swift-testing-performance"),
        .package(path: "../../coenttb/swift-formatting")
    ],
    targets: [
        .target(
            name: "Standards",
            dependencies: [
                .product(name: "Formatting", package: "swift-formatting")
            ]
        ),
        .target(
            name: "StandardsTestSupport",
            dependencies: [
                "Standards",
                .product(name: "TestingPerformance", package: "swift-testing-performance")
            ]
        ),
        .testTarget(
            name: "Standards Tests",
            dependencies: [
                "Standards",
                "StandardsTestSupport"
            ]
        )
    ]
)

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(
        .enableUpcomingFeature("MemberImportVisibility")
    )
    target.swiftSettings = settings
}

