// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoD Tool Package",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        // MARK: - Executable Products
        
        .executable(
            name: "GoD Tool App",
            targets: ["GoD Tool UI"]
        ),
        .executable(
            name: "GoD Tool CLI",
            targets: ["GoD Tool CLI"]
        ),
        .executable(
            name: "GoD Tool Script",
            targets: ["GoD Tool Script"]
        ),
        .executable(
            name: "Discord Plays Orre",
            targets: ["Discord Plays Orre"]
        ),
        
        // MARK: - Base Library Products
        
        .library(
            name: "BaseApp",
            targets: ["BaseApp"]
        ),
        .library(
            name: "BaseCLI",
            targets: ["BaseCLI"]
        ),
        .library(
            name: "BaseScript",
            targets: ["BaseScript"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // MARK: - Executable Targets
        
        .executableTarget(
            name: "GoD Tool UI",
            dependencies: [
                "BaseApp"
            ],
            path: "Sources/Products/GoD Tool UI"
        ),
        .executableTarget(
            name: "GoD Tool CLI",
            dependencies: [
                "BaseCLI",
            ],
            path: "Sources/Products/GoD Tool CLI"
        ),
        .executableTarget(
            name: "GoD Tool Script",
            dependencies: [
                "BaseScript",
            ],
            path: "Sources/Products/GoD Tool Script"
        ),
        .executableTarget(
            name: "Discord Plays Orre",
            dependencies: [
            ],
            path: "Sources/Products/Discord Plays Orre"
        ),
        
        // MARK: - Base Library Targets
        
        .target(
            name: "BaseApp",
            dependencies: [
                "GoDEngine",
                "GameCube",
                "GoDFoundation",
                "GoDGUI",
                "GoDNetworking",
                "Config"
            ],
            path: "Sources/Base/App",
            resources: []
        ),
        .target(
            name: "BaseCLI",
            dependencies: [
                "GoDFoundation",
                "GoDEngine",
                "GameCube",
                "GoDCLI",
                "Config"
            ],
            path: "Sources/Base/CLI",
            resources: []
        ),
        .target(
            name: "BaseScript",
            dependencies: [
                "GoDFoundation",
                "GoDEngine",
                "GameCube",
                "Config"
            ],
            path: "Sources/Base/Script",
            resources: []
        ),
        
        // MARK: - Core Library Targets
        
        .target(
            name: "GoDGUI",
            dependencies: [
                
            ],
            path: "Sources/Shared/Core/Contexts/GUI",
            resources: [.process("Resources")]
        ),
        .target(
            name: "GoDCLI",
            dependencies: [
                "GoDFoundation",
                "GenericEngine",
                "Config"
            ],
            path: "Sources/Shared/Core/Contexts/CLI",
            resources: [.process("Resources")]
        ),
        
        // MARK: - Core Library Engine Targets

        .target(
            name: "GoDEngine",
            dependencies: [
                "GoDFoundation",
                "Structs"
            ],
            path: "Sources/Shared/Core/Engines/Engine"),
        .target(
            name: "GenericEngine",
            dependencies: [
                "GoDFoundation"
            ],
            path: "Sources/Shared/Core/Engines/Generic"),
        .target(
            name: "Colosseum",
            dependencies: [
                "GoDFoundation",
                "GameCube",
                "Pokemon"
            ],
            path: "Sources/Shared/Core/Engines/Colosseum",
            resources: [.process("Resources")]
        ),
        .target(
            name: "GameCube",
            dependencies: [
                "GoDEngine",
                "GoDFoundation",
                "Structs"
            ],
            path: "Sources/Shared/Core/Engines/GameCube",
            resources: [.process("Resources")]
        ),
        .target(
            name: "PBR",
            dependencies: [
                "GoDFoundation",
                "Wii",
                "Pokemon"
            ],
            path: "Sources/Shared/Core/Engines/PBR",
            resources: [.process("Resources")]
        ),
        .target(
            name: "Pokemon",
            dependencies: [
                "GoDFoundation"
            ],
            path: "Sources/Shared/Core/Engines/Pokemon",
            resources: [.process("Resources")]
        ),
        .target(
            name: "Wii",
            dependencies: [
                "GoDFoundation"
            ],
            path: "Sources/Shared/Core/Engines/Wii",
            resources: [.process("Resources")]
        ),
        .target(
            name: "XD",
            dependencies: [
                "GoDFoundation",
                "GameCube",
                "Pokemon"
            ],
            path: "Sources/Shared/Core/Engines/XD",
            resources: [.process("Resources")]
        ),
        
        // MARK: - Feature Library Targets
        .target(
            name: "Config",
            dependencies: [
                "GoDFoundation",
            ],
            path: "Sources/Shared/Features/Config",
            resources: []
        ),
        
        // MARK: - Dependency Library Targets
        .target(
            name: "Colors",
            dependencies: [
            ],
            path: "Sources/Shared/Dependencies/Colors",
            resources: []
        ),
        .target(
            name: "GoDFoundation",
            dependencies: [
            ],
            path: "Sources/Shared/Dependencies/GoDFoundation",
            resources: []
        ),
        .target(
            name: "GoDISO",
            dependencies: [
                "GoDFoundation",
                "Structs"
            ],
            path: "Sources/Shared/Features/ISO",
            resources: []
        ),
        .target(
            name: "GoDNetworking",
            dependencies: [
                "GoDFoundation"
            ],
            path: "Sources/Shared/Dependencies/Networking",
            resources: []
        ),
        .target(
            name: "Structs",
            dependencies: [
                "GoDFoundation",
            ],
            path: "Sources/Shared/Dependencies/Structs",
            resources: []
        ),
        
        // MARK: - Third Party Dependency Library Targets
        .target(
            name: "ArgumentParser",
            dependencies: [
            ],
            path: "Sources/Shared/Dependencies/Third Party/ArgumentParser/Sources",
            resources: []
        ),
        .target(
            name: "SwiftPNG",
            dependencies: [
            ],
            path: "Sources/Shared/Dependencies/Third Party/SwiftPNG/sources",
            resources: []
        ),
        .target(
            name: "xxHash",
            dependencies: [
            ],
            path: "Sources/Shared/Dependencies/Third Party/xxHash",
            resources: []
        ),
        
        // MARK: - Test Targets
        
        .testTarget(
            name: "GoDFoundationTests",
            dependencies: ["GoDFoundation"],
            path: "Tests/Shared Tests/Dependency Tests/GoD Foundation Tests",
            resources: [.process("Resources")]),
        .testTarget(
            name: "GoDStructTests",
            dependencies: ["Structs"],
            path: "Tests/Shared Tests/Dependency Tests/GoD Struct Tests"),
        .testTarget(
            name: "SwiftPNGTests",
            dependencies: ["SwiftPNG"],
            path: "Sources/Shared/Dependencies/Third Party/SwiftPNG/tests"),
        .testTarget(
            name: "ArgumentParserTests",
            dependencies: [
                "ArgumentParser"
            ],
            path: "Sources/Shared/Dependencies/Third Party/ArgumentParser/Tests",
            resources: []
        ),
    ]
)

