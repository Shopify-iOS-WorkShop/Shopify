// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProductListing",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ProductListing",
            targets: ["ProductListing"]),
    ]
    ,dependencies: [
        .package(path: "../shopify-network")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ProductListing",
            dependencies: [
                // Explicitly tells SPM: "Look for the product 'ShopifyNetwork' inside the package 'shopify-network'"
                .product(name: "ShopifyNetwork", package: "shopify-network")
            ]),
        .testTarget(
            name: "ProductListingTests",
            dependencies: ["ProductListing",.product(name: "ShopifyNetwork", package: "shopify-network")]),
    ]
)
