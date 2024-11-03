// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSDLTest",
    platforms: [
      .iOS(.v13),
      .tvOS(.v13),
      .macOS(.v10_15)
    ],
    dependencies: [
      .package(url: "https://github.com/KevinVitale/SwiftSDL.git", from: "0.2.0-alpha.8"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "SwiftSDLTest",
            dependencies: [
              "SwiftSDL"
            ],
            resources: [
              .process("../Resources/BMP")
            ],
            linkerSettings: [
              .unsafeFlags([
                "-Xlinker", "-sectcreate",
                "-Xlinker", "__TEXT",
                "-Xlinker", "__info_plist",
                "-Xlinker", "Resources/Info.plist"
              ], .when(platforms: [.iOS]))
            ]
        ),
    ]
)
