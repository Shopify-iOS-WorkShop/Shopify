// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DataPersistence",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DataPersistence", targets: ["DataPersistence"])
    ],
    targets: [
        .target(
            name: "DataPersistence",
            dependencies: [],
            path: "Sources/DataPersistence"
        )
    ]
)
