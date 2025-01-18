//
//  main.swift
//  
//
//  Created by Stars Momodu on 04/06/2024.
//

import GoDFoundation
import Structs
import GameCube
import Dolphin

let mode = RunModes.development(args: [
//    "/Users/stars/Documents/GoD Tool/XD.iso",
//    "/Users/stars/Documents/GoD Tool/XD Project/Build/ISO/XD.iso",
    "/Users/stars/Documents/GoD Tool/XD project/Config/Dump-Config.json"
])

//let mode = RunModes.commandLine

do {
    let arguments = mode.arguments
    guard arguments.count > 0 else {
        print("No input files provided. Exiting program.")
        exit(EXIT_FAILURE)
    }
    
    let fileSystem = FileSystem.shared
    for inputFile in arguments.map({ File($0) }) {
        guard inputFile.path != Bundle.main.executablePath else {
            continue
        }
        switch inputFile.fileType {
        case "iso", "gcm":
            try Project.setup(iso: inputFile, isoContents: nil)
        case "json":
            let config: GoddessConfig = try fileSystem.decodeJSON(from: inputFile)
            
            let settings: GoddessSettings = try config.settingsFile.flatMap { file in
                return try fileSystem.decodeJSON(from: file)
            } ?? GoddessSettings.default
            
            try config.operations
                .enabledEntries
                .forEach { operation in
                    switch operation {
                    case .gamecubeDump(let config):
                        try Gamecube.dump(config: config, settings: settings)
                    case .gamecubeBuild(let config):
                        try Gamecube.build(config: config, settings: settings)
                    }
                }
        default:
            print("Unsupported file type '\(inputFile.fileType)' for file \(inputFile)")
        }
    }
} catch let error {
    print(error)
}
