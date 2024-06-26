// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UI",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UI",
            targets: ["UI"]),
    ],
    dependencies: [
        .package(path: "../API"),
        .package(path: "../ViewModel"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UI",
            dependencies: [
                "API", "ViewModel",
                .product(name: "Preview", package: "API")]),
        .testTarget(
            name: "UITests",
            dependencies: ["UI"]),
    ]
)
