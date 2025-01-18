//
//  File.swift
//  
//
//  Created by Stars Momodu on 09/06/2024.
//

import GoDFoundation
import GoDEngine
import GameCube

extension Gamecube {
    static func build(config: BuildConfig, settings: GoddessSettings) throws {
        let engine = CombinedEngine.from(files: config.engines)
        let fileSystem = FileSystem.shared
        try config.operations.enabledEntries.forEach { operation in
            switch operation {
            case .buildISO(let fstPath, let isoPath, let overwrite):
                let iso = GamecubeISO(fst: fileSystem, rootFolder: fstPath, engine: engine)
                let data = try iso.data
                fileSystem.writeFile(data, at: isoPath, overwrite: overwrite)
            case .fillISO(let isoPath, let size):
                guard let iso = FileSystem.shared.readFile(at: isoPath) else {
                    throw FSTErrors.fileNotFound(isoPath)
                }
                let remaining = size - iso.length
                if remaining > 0 {
                    iso.append(GoDData(length: remaining))
                    FileSystem.shared.writeFile(iso, at: isoPath, overwrite: true)
                }
                
            }
        }
    }
}
