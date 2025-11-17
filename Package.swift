// swift-tools-version: 6.0

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
        )
    ],
    targets: [
        .target(
            name: "Standards"
        ),
        .testTarget(
            name: "Standards Tests",
            dependencies: ["Standards"]
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

