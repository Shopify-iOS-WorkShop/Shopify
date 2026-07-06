// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShopifyNetwork",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ShopifyNetwork",
            targets: ["ShopifyNetwork", "ShopifyAdminNetwork"]
        ),
        .library(
            name: "ShopifyAdminNetwork",
            targets: ["ShopifyAdminNetwork"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apollographql/apollo-ios.git", "1.8.0"..<"1.18.0"
        ),
        .package(path: "../DependencyInjection")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ShopifyNetwork",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "ApolloAPI", package: "apollo-ios"),
                .product(name: "DependencyInjection", package: "DependencyInjection")
            ],
            exclude: ["GraphQL/schema.graphqls"]
        ),
        .target(
            name: "ShopifyAdminNetwork",
            dependencies: [
                "ShopifyNetwork",
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "ApolloAPI", package: "apollo-ios")
            ]
        ),
        .testTarget(
            name: "ShopifyNetworkTests",
            dependencies: [
                "ShopifyNetwork",
                .product(name: "DependencyInjection", package: "DependencyInjection")
            ]
        ),
    ]
)
