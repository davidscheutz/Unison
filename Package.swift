// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Unison",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Unison", targets: ["Unison"]),
        .plugin(name: "CodeGeneratorPlugin", targets: ["CodeGeneratorPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/davidscheutz/SwiftDependencyContainer.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "Unison",
            dependencies: [
                .product(name: "SwiftDependencyContainer", package: "SwiftDependencyContainer")
            ]
        ),
        .plugin(
            name: "CodeGeneratorPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "sourcery")
            ]
        ),
        .binaryTarget(
            name: "sourcery",
            path: "Binaries/sourcery.artifactbundle"
        ),
        .testTarget(
            name: "UnisonTests",
            dependencies: ["Unison"]),
    ]
)
