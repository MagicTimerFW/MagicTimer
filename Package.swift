// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MagicTimer",
    platforms: [.iOS("11.0")],
    products: [
        .library(
            name: "MagicTimer",
            targets: ["MagicTimer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sadeghgoo/MathOperators.git", branch: "main")
    ],
    targets: [
        .target(
            name: "MagicTimer",
            dependencies: [
                .product(
                    name: "MathOperators",
                    package: "MathOperators"),
            ]),
        .testTarget(
            name: "MagicTimerTests",
            dependencies: ["MagicTimer"]),
    ]
)
