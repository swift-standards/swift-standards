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
            name: "Time",
            targets: ["Time"]
        ),
        .library(
            name: "StandardsTestSupport",
            targets: ["StandardsTestSupport"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-testing-performance", from: "0.1.0"),
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
            name: "Time",
            dependencies: [
                "Standards"
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
        ),
        .testTarget(
            name: "Time Tests",
            dependencies: [
                "Time",
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

