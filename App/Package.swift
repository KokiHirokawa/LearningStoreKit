// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "PremiumFeature", targets: ["PremiumFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.38.3")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "PremiumFeature"
            ]
        ),
        .testTarget(name: "AppTests", dependencies: ["App"]),

        .target(
            name: "PremiumFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
