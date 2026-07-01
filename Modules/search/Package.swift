// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "search",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "search",
            targets: ["search"]
        ),
    ],
    dependencies: [
        .package(path: "../shopify-network")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "search",
            dependencies: [
                .product(name: "ShopifyNetwork", package: "shopify-network")
            ]
        ),
        .testTarget(
            name: "searchTests",
            dependencies: ["search"]
        ),
    ]
)
