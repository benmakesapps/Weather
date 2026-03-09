// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Weather",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Weather", targets: ["Weather"]),
    ],
    targets: [
        .target(name: "Weather"),
        .testTarget(name: "WeatherTests", dependencies: ["Weather"]),
    ]
)
