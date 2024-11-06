// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "GitBranchCleaner",
  platforms: [.macOS("13")],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", branch: "1.3.0"),
    .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "GitBranchCleaner",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "ShellOut", package: "ShellOut"),
      ]
    ),
    .testTarget(
      name: "GitBranchCleanerTests",
      dependencies: ["GitBranchCleaner"]
    ),
  ]
)
