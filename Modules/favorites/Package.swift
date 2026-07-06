// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Favorites",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Favorites", targets: ["Favorites"])
    ],
    dependencies: [
        .package(path: "../DataPersistence"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "Favorites",
            dependencies: [
                .product(name: "DataPersistence", package: "DataPersistence"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "Common", package: "Common")
            ],
            path: "Sources/favorites"
        ),
        .testTarget(
            name: "FavoritesTests",
            dependencies: ["Favorites"],
            path: "Tests/FavoritesTests"
        )
    ]
)
