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
    targets: [
        .target(
            name: "MagicTimer",
            dependencies: []),
        .testTarget(
            name: "MagicTimerTests",
            dependencies: ["MagicTimer"]),
    ]
)
