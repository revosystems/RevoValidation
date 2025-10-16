// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "RevoValidation",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RevoValidation",
            targets: ["RevoValidation"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/revosystems/foundation.git", .upToNextMinor(from: "0.3.1"))
    ],
    targets: [
        .target(
            name: "RevoValidation",
            dependencies: [
                .product(name: "RevoFoundation", package: "foundation")
            ],
            path: "RevoValidation/src"
        ),
        .testTarget(
            name: "RevoValidationTests",
            dependencies: ["RevoValidation"],
            path: "RevoValidationTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
