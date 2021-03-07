// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGoogleCloudTTS",
    products: [
        .library(name: "SwiftGoogleCloudTTS", targets: ["SwiftGoogleCloudTTS"]),
    ],
    dependencies: [
        .package(name: "grpc-swift", url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0"),
        .package(name: "SwiftProtobuf", url: "https://github.com/apple/swift-protobuf.git", from: "1.7.0"),
        .package(name: "Auth", url: "https://github.com/googleapis/google-auth-library-swift.git", from: "0.5.1")
    ],
    targets: [
        .target(name: "SwiftGoogleCloudTTS", dependencies: [
            .product(name: "GRPC", package: "grpc-swift"), 
            .product(name: "SwiftProtobuf", package: "SwiftProtobuf"), 
            .product(name: "OAuth2", package: "Auth")
        ]),
        .testTarget(
            name: "SwiftGoogleCloudTTSTests",
            dependencies: ["SwiftGoogleCloudTTS"]),
    ]
)
