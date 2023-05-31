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
        .package(url: "../SwiftDependencyContainer", revision: "02c6fac3e60660127dcc6e026f90145fdb1a3ac6")
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
