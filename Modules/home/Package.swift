// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Home",
            targets: ["Home"]),
    ],
    dependencies: [
        .package(path: "../shopify-network"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Common")
    ],
    targets: [
            .target(
                name: "Home",
                dependencies: [
                    // Explicitly tells SPM: "Look for the product 'ShopifyNetwork' inside the package 'shopify-network'"
                    .product(name: "ShopifyNetwork", package: "shopify-network"),
                    .product(name: "DependencyInjection", package: "DependencyInjection"),
                    .product(name: "Common", package: "Common")
                ]
            ),
            .testTarget(
                name: "HomeTests",
                dependencies: [
                    "Home",
                    .product(name: "ShopifyNetwork", package: "shopify-network"),
                    .product(name: "DependencyInjection", package: "DependencyInjection"),
                    .product(name: "Common", package: "Common")
                ]
            ),
        ]
)
