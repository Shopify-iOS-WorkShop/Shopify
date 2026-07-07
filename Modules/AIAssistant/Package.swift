// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AIAssistant",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AIAssistant",
            targets: ["AIAssistant"]),
    ],
    dependencies: [
        .package(url: "https://github.com/google-gemini/generative-ai-swift", from: "0.5.0"),
        .package(path: "../shopify-network"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "AIAssistant",
            dependencies: [
                .product(name: "GoogleGenerativeAI", package: "generative-ai-swift"),
                .product(name: "ShopifyNetwork", package: "shopify-network"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "Common", package: "Common")
            ]
        ),
        .testTarget(
            name: "AIAssistantTests",
            dependencies: [
                "AIAssistant"
            ]
        ),
    ]
)
