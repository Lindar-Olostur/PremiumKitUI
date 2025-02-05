// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UtilityHelper",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UtilityHelper",
            targets: ["UtilityHelper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apphud/ApphudSDK", "3.5.9"..<"4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UtilityHelper",
            dependencies: [
                .product(name: "ApphudSDK", package: "ApphudSDK") // Link ApphudSDK
            ]),
    ]
)
