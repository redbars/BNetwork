// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BNetwork",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BNetwork",
            targets: ["BNetwork"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "BNetwork",
            dependencies: []),
        .testTarget(
            name: "BNetworkTests",
            dependencies: []),
    ]
)
