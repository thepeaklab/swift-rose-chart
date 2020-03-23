// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-rose-chart",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "RoseChart", targets: ["RoseChart"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "RoseChart",
            dependencies: [],
            exclude: ["Example"]),
        .testTarget(
            name: "RoseChartTests",
            dependencies: ["RoseChart"],
            exclude: ["Example"]),
    ]
)
