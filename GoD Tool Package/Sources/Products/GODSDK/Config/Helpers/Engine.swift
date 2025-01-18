//
//  File.swift
//  
//
//  Created by Stars Momodu on 09/06/2024.
//

import GoDFoundation
import GoDEngine

extension CombinedEngine {
    static func from(files: [File]) -> CombinedEngine {
        let fileSystem = FileSystem.shared
        let engines: [CustomEngine] = files.compactMap { file in
            return try? fileSystem.decodeJSON(from: file)
        }
        return CombinedEngine(name: "Combined Engine", description: "", engines: engines)
    }
}
