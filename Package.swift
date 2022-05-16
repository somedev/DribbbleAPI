// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DribbbleAPI",
    products: [
        .library(
            name: "DribbbleAPI",
            targets: ["DribbbleAPI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DribbbleAPI",
            dependencies: []),
        .testTarget(
            name: "DribbbleAPIAPITests",
            dependencies: ["DribbbleAPI"]),
    ]
)
