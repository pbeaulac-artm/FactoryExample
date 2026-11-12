// swift-tools-version: 6.1
import PackageDescription

let features = ["LoremFeature", "BeerFeature", "CoffeeFeature", "SpaceFeature", "PirateFeature"]
let factory: Target.Dependency = .product(name: "FactoryKit", package: "Factory")

let package = Package(
    name: "IpsumPackages",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: (features + ["IpsumModels", "IpsumDependencies", "IpsumDatabase", "IpsumRepositoryLive"]).map {
        .library(name: $0, targets: [$0])
    },
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", exact: "3.5.3")
    ],
    targets: [
        .target(name: "IpsumModels"),
        .target(name: "IpsumRepository", dependencies: ["IpsumModels"]),
        .target(name: "IpsumDatabase", dependencies: ["IpsumModels"]),
        .target(name: "IpsumRepositoryLive", dependencies: ["IpsumRepository", "IpsumDatabase"]),
        .target(name: "IpsumUseCases", dependencies: ["IpsumRepository"]),
        .target(name: "IpsumDependencies", dependencies: ["IpsumUseCases", factory]),
        .target(name: "IpsumUI", dependencies: ["IpsumModels"])
    ] + features.map {
        .target(name: $0, dependencies: ["IpsumDependencies", "IpsumModels", "IpsumUseCases", "IpsumUI", factory])
    } + [
        .testTarget(
            name: "IpsumTests",
            dependencies: features.map { .byName(name: $0) } + [
                "IpsumDependencies", "IpsumModels", "IpsumUseCases", "IpsumRepository",
                "IpsumRepositoryLive", "IpsumDatabase",
                .product(name: "FactoryTesting", package: "Factory")
            ]
        )
    ]
)
