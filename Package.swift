// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGoogleCloudTTS",
    products: [
        .library(name: "SwiftGoogleCloudTTS", targets: ["SwiftGoogleCloudTTS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0-alpha.6"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.7.0"),
        .package(url: "https://github.com/googleapis/google-auth-library-swift.git", from: "0.5.1")
    ],
    targets: [
        .target(
            name: "SwiftGoogleCloudTTS",
            dependencies: ["GRPC", "SwiftProtobuf", "OAuth2"]),
        .testTarget(
            name: "SwiftGoogleCloudTTSTests",
            dependencies: ["SwiftGoogleCloudTTS"]),
    ]
)
