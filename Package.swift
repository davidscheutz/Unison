// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Unison",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Unison", targets: ["Unison"])
    ],
    dependencies: [
        .package(path: "../SwiftDependencyContainer")
    ],
    targets: [
        .target(
            name: "Unison",
            dependencies: [
                .product(name: "SwiftDependencyContainer", package: "SwiftDependencyContainer")
            ]
        ),
        .testTarget(
            name: "UnisonTests",
            dependencies: ["Unison"]),
    ]
)
