// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DataPersistence",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DataPersistence", targets: ["DataPersistence"])
    ],
    dependencies: [
        .package(path: "../DependencyInjection")
    ],
    targets: [
        .target(
            name: "DataPersistence",
            dependencies: [
                .product(name: "DependencyInjection", package: "DependencyInjection")
            ],
            path: "Sources/DataPersistence"
        )
    ]
)
