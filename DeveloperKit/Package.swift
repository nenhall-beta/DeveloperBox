// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DeveloperKit",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "DeveloperKit",
            targets: ["DeveloperKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "1.9.6")),
    ],
    targets: [
        .target(
            name: "DeveloperKit",
            dependencies: ["SwiftyBeaver"],
            resources: [Resource.copy("shell")],
            linkerSettings: [
//                .linkedFramework("Python3", .when(platforms: [.macOS]))
            ]
        ),
        .testTarget(
            name: "DeveloperKitTests",
            dependencies: ["DeveloperKit"],
            linkerSettings: [
//                .linkedFramework("Python3", .when(platforms: [.macOS]))
            ]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
