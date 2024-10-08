// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "API",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "API",
            targets: ["API"]),
        .library(
            name: "Preview",
            targets: ["Preview"]),
        .library(
            name: "Implementation",
            targets: ["Implementation"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "API"),
        .target(
            name: "Implementation",
            dependencies: ["API"]),
        .target(
            name: "Preview",
            dependencies: ["API", "Implementation"],
            resources: [.process("SampleResponses")]),
        .testTarget(
            name: "APITests",
            dependencies: ["API", "Implementation", "Preview"],
            swiftSettings: [
                // Suppress the deprecation warning in `UrlSessionMock.init`.
                .unsafeFlags(["-suppress-warnings"]),
            ]),
    ]
)
