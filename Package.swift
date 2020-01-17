// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-google-tts",
    products: [
        .library(name: "swift-google-tts", targets: ["swift-google-tts"]),
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0-alpha.6"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.7.0"),
        .package(url: "https://github.com/googleapis/google-auth-library-swift.git", from: "0.5.0")
    ],
    targets: [
        .target(
            name: "swift-google-tts",
            dependencies: ["GRPC", "SwiftProtobuf", "OAuth2"]),
        .testTarget(
            name: "swift-google-ttsTests",
            dependencies: ["swift-google-tts"]),
    ]
)
