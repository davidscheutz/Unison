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
    dependencies: [],
    targets: [
        .target(
            name: "Unison"
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
