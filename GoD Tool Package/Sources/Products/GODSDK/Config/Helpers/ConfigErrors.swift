//
//  File.swift
//  
//
//  Created by Stars Momodu on 09/06/2024.
//

import GoDFoundation

enum ConfigErrors: Error, CustomStringConvertible {
    case settingsFileNotFound(File)
    
    var description: String {
        switch self {
        case .settingsFileNotFound(let file):
            return "Error: Couldn't read settings file at: \(file)"
        }
    }
}
