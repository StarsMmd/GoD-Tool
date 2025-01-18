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
    static func dump(config: DumpConfig, settings: GoddessSettings) throws {
        let engine = CombinedEngine.from(files: config.engines)
        let fileSystem = FileSystem.shared
        try config.operations.enabledEntries.forEach { operation in
            switch operation {
            case .unpackISO(let isoPath, let fstFolder, let overwrite):
                guard let data = fileSystem.readFile(at: isoPath) else {
                    throw FSTErrors.fileNotFound(isoPath)
                }
                let iso = try GamecubeISO(data: data, engine: engine)
                fileSystem.write(iso, at: fstFolder, overwrite: overwrite)
            case .dumpXD(let fstFolder, let outputFolder, let overwrite):
                // TODO: option to use dolphin file names for images
                let inputFST = InMemoryFST()
                inputFST.importFST(fileSystem, from: fstFolder, to: "/", overwrite: true)
                try dumpColosseumXD(
                    inputFST: inputFST,
                    outputFST: fileSystem,
                    outputFolder: outputFolder,
                    overwrite: overwrite,
                    engine: CombinedEngine.from(files: config.engines),
                    settings: settings
                )
            }
        }
    }
}
