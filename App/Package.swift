// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "EntranceFeature", targets: ["EntranceFeature"]),
        .library(name: "ComposableStoreKit", targets: ["ComposableStoreKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.38.3")
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "ComposableStoreKit",
                "EntranceFeature"
            ]
        ),
        .testTarget(name: "AppTests", dependencies: ["AppFeature"]),
        .target(
            name: "EntranceFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "ComposableStoreKit"
            ]
        ),
        .target(
            name: "ComposableStoreKit",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
