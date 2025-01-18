//
//  GamecubeDumpConfig.swift
//  
//
//  Created by Stars Momodu on 08/06/2024.
//

import GoDFoundation

extension Gamecube {
    struct DumpConfig: Codable {
        enum Operations: Codable {
            case unpackISO(isoPath: File, fstFolder: Folder, overwrite: Bool)
            case dumpXD(fstFolder: Folder, outputFolder: Folder, overwrite: Bool)
//            case decodeXD(fstFolder: Folder, outputFolder: Folder, projectFolder: Folder, overwrite: Bool)
        }
        
        let engines: [File]
        let operations: [OperationConfig<Operations>]
    }
}
