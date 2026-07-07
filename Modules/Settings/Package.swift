// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Settings", targets: ["Settings"])
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(path: "../shopify-network"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Auth")
    ],
    targets: [
        .target(
            name: "Settings",
            dependencies: [
                .product(name: "Common", package: "Common"),
                .product(name: "ShopifyNetwork", package: "shopify-network"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "Auth", package: "Auth"),
            ]
        ),
        .testTarget(
            name: "SettingsTests",
            dependencies: ["Settings"]
        )
    ]
)
