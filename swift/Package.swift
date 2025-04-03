// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "GodotVrTest",
  platforms: [.macOS("14")],
  products: [
    .library(name: "GodotVrTest", type: .dynamic, targets: ["GodotVrTest"])
  ],
  dependencies: [
    .package(url: "https://github.com/migueldeicaza/SwiftGodot", branch: "main")
  ],
  targets: [
    .target(
      name: "GodotVrTest",
      dependencies: ["SwiftGodot"],
      swiftSettings: [.unsafeFlags(["-suppress-warnings"])]
    )
  ]
)
