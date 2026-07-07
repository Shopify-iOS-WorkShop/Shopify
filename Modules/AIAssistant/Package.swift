// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AIAssistant",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "AIAssistant", targets: ["AIAssistant"]),
    ],
    targets: [
        .target(
            name: "AIAssistant",
            path: "Sources/AIAssistant",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "AIAssistantTests",
            dependencies: ["AIAssistant"],
            path: "Tests/AIAssistantTests"
        ),
    ]
)
