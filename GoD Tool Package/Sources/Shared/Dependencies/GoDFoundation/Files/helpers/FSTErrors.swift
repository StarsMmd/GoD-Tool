//
//  File.swift
//  
//
//  Created by Stars Momodu on 09/06/2024.
//

import Foundation

public enum FSTErrors: Error, CustomStringConvertible {
    case fileNotFound(File)
    case folderNotFound(Folder)
    
    public var description: String {
        switch self {
        case .fileNotFound(let file):
            return "Error: file not found: \(file)"
        case .folderNotFound(let folder):
            return "Error: folder not found: \(folder)"
        }
    }
}
