// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSDLTest",
    platforms: [.macOS(.v10_15)],
    dependencies: [
      .package(url: "https://github.com/KevinVitale/SwiftSDL.git", from: "0.2.0-alpha.4"),
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
              .unsafeFlags(
                [
                "-Xlinker", "-F", "-Xlinker", "/usr/local/lib",
                "-Xlinker", "-rpath", "-Xlinker", "/usr/local/lib",
              ], .when(platforms: [.macOS]))
            ]
        ),
    ]
)
