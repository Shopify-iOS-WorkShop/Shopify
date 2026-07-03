// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Cart",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Cart", targets: ["Cart"])
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(path: "../shopify-network"),
        .package(path: "../DataPersistence"),
        .package(path: "../DependencyInjection"),
        .package(
            url: "https://github.com/apollographql/apollo-ios",
            from: "2.2.0"
        ),
    ],
    targets: [
        .target(
            name: "Cart",
            dependencies: [
                .product(name: "Common", package: "Common"),
                .product(name: "ShopifyNetwork", package: "shopify-network"),
                .product(name: "DataPersistence", package: "DataPersistence"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "ApolloAPI", package: "apollo-ios"),
            ],
            path: "Sources/Cart"
        )
    ]
)
