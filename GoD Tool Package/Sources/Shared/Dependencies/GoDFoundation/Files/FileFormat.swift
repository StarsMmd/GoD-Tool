//
//  FileFormat.swift
//  
//
//  Created by Stars Momodu on 06/06/2024.
//

import Foundation

public protocol FileFormat {
    static var formatName: String { get }
}

public enum FileFormatErrors: Error, CustomStringConvertible {
    case invalidFileData(format: FileFormat.Type)
    case failedToEncode(format: FileFormat.Type, target: String)
    
    public var description: String {
        switch self {
        case .invalidFileData(let format):
            return "Error: Invalid data for file format '\(format.formatName)'"
        case .failedToEncode(let format, let target):
            return "Error: Failed to encode file format '\(format.formatName)' to '\(target)'"
        }
    }
}

public extension FileFormat {
    static var invalidFileError: Error {
        FileFormatErrors.invalidFileData(format: Self.self)
    }
    
    static func failedToEncodeError(target: String) -> Error {
        FileFormatErrors.failedToEncode(format: Self.self, target: target)
    }
}
