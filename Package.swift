// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViberUIGridView",
    platforms: [
        .iOS(.v13)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UIGrid",
            targets: ["UIGrid"]),
        .library(
            name: "UIGridView",
            targets: ["UIGridView"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UIGrid"),
        .target(
            name: "UIGridView",
            dependencies: ["UIGrid"]),
        .testTarget(
            name: "UIGridViewTests",
            dependencies: ["UIGridView"],
            resources: [
                // Copy Tests/ExampleTests/Resources directories as-is.
                // Use to retain directory structure.
                // Will be at top level in bundle.
                .copy("jsons"),
            ]),
        .testTarget(
            name: "UIGridTests",
            dependencies: ["UIGrid"],
            resources: [
                // Copy Tests/ExampleTests/Resources directories as-is.
                // Use to retain directory structure.
                // Will be at top level in bundle.
                .copy("jsons"),
            ]),
    ]
)
