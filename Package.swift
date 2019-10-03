// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JKCSFacilities_iOS",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "JKCSFacilities_iOS",
            targets: ["JKCSFacilities_iOS"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ashleymills/Reachability.swift.git", from: Version(4, 3, 1))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "JKCSFacilities_iOS",
            dependencies: ["Reachability"]),
        .testTarget(
            name: "JKCSFacilities_iOSTests",
            dependencies: ["JKCSFacilities_iOS"]),
    ]
)
