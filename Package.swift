// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIAppAuthentication",
    dependencies: [
        // This just points to the SwiftPM at the root of this repository.
        .package(path: "src/Swift/APIAppAuthentication"),
        // You will want to depend on a stable semantic version instead:
        // .package(url: "https://github.com/apple/swift-package-manager", .exact("0.4.0"))
    ],
    targets: [
        .target(
            name: "APIAppAuthentication"
    ]
)