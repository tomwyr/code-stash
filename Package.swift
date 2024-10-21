// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitBranchCleaner",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "1.3.0")
    ],
    targets: [
        .executableTarget(
            name: "GitBranchCleaner",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
    ]
)
