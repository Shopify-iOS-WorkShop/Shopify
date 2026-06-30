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
        .package(path: "../shopify-network")
    ],
    targets: [
            .target(
                name: "Home",
                dependencies: [
                    // Explicitly tells SPM: "Look for the product 'ShopifyNetwork' inside the package 'shopify-network'"
                    .product(name: "ShopifyNetwork", package: "shopify-network")
                ]
            ),
            .testTarget(
                name: "HomeTests",
                dependencies: [
                    "Home",
                    .product(name: "ShopifyNetwork", package: "shopify-network")
                ]
            ),
        ]
)
