// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "KfchycGithubIo",
    products: [
        .executable(
            name: "KfchycGithubIo",
            targets: ["KfchycGithubIo"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "KfchycGithubIo",
            dependencies: ["Publish"]
        )
    ]
)