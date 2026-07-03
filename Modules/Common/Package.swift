// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        
        .library(
            name: "Common",
            targets: ["Common"]
        ),
    ]
    ,dependencies: [
        .package(path: "../shopify-network")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Common",
            dependencies: [
                // Explicitly tells SPM: "Look for the product 'ShopifyNetwork' inside the package 'shopify-network'"
                .product(name: "ShopifyNetwork", package: "shopify-network")
            ]
        ),
        .testTarget(
            name: "CommonTests",
            dependencies: ["Common",.product(name: "ShopifyNetwork", package: "shopify-network")]
        ),
    ]
)
