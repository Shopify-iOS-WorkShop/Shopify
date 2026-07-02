// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Home",
            targets: ["Home"]),
    ]
    ,dependencies: [
        .package(path: "../shopify-network"),
        .package(path: "../DependencyInjection")
    ],
    targets: [
            .target(
                name: "Home",
                dependencies: [
                    .product(name: "ShopifyNetwork", package: "shopify-network"),
                    .product(name: "DependencyInjection", package: "DependencyInjection")
                ]
            ),
            .testTarget(
                name: "HomeTests",
                dependencies: [
                    "Home",
                    .product(name: "ShopifyNetwork", package: "shopify-network"),
                    .product(name: "DependencyInjection", package: "DependencyInjection")
                ]
            ),
        ]
)
