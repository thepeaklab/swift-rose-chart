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
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "RoseChart", dependencies: []),
        .testTarget(name: "RoseChartTests", dependencies: ["RoseChart"]),
    ]
)
