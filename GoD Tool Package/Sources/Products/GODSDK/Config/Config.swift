//
//  File.swift
//  
//
//  Created by Stars Momodu on 08/06/2024.
//

import GoDFoundation

struct GoddessConfig: Codable {
    enum Operations: Codable {
        case gamecubeDump(config: Gamecube.DumpConfig)
        case gamecubeBuild(config: Gamecube.BuildConfig)
    }
    
    let name: String
    let description: String?
    let settingsFile: File?
    let operations: [OperationConfig<Operations>]
}
