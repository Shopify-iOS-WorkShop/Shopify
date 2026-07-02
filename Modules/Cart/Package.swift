// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cart",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Cart",
            targets: ["Cart"]
        ),
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(path: "../DataPersistence"),
        .package(path: "../shopify-network"),
        .package(path: "../DependencyInjection")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Cart",
            dependencies: [
                "Common",
                .product(name: "DataPersistence", package: "DataPersistence"),
                .product(name: "ShopifyNetwork", package: "shopify-network"),
                .product(name: "DependencyInjection", package: "DependencyInjection")
            ]
        ),
        .testTarget(
            name: "CartTests",
            dependencies: ["Cart"]
        ),
    ]
)
