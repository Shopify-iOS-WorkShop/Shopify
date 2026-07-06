// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Addresss",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Addresss",
            targets: ["Addresss"]
        ),
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(path: "../shopify-network"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Auth"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Addresss",
            dependencies: [
                "Common",
                "Auth",
                .product(name: "ShopifyNetwork", package: "shopify-network"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
            ]
        ),
        .testTarget(
            name: "AddresssTests",
            dependencies: ["Addresss"]
        ),
    ]
)
