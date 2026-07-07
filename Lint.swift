// swift-linter-tools-version: 0.1
// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-standards open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-standards project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Linter
import Linter_Standards_Rules

Lint.run(dependencies: [
    .package(
        url: "https://github.com/swift-standards/swift-standards-linter-rules.git",
        branch: "main",
        products: ["Linter Standards Rules"]
    ),
]) {
    Lint.Rule.Bundle.standards
}
