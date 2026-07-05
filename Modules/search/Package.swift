// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "search",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "search",
            targets: ["search"]
        ),
    ],
    dependencies: [
        .package(path: "../shopify-network"),
        .package(path: "../DependencyInjection"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "2.2.0")
    ],
    targets: [
        .target(
            name: "search",
            dependencies: [
                .product(name: "ShopifyNetwork", package: "shopify-network"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "Apollo", package: "apollo-ios")
            ]
        ),
        .testTarget(
            name: "searchTests",
            dependencies: ["search"]
        ),
    ]
)
