//
//  Folder.swift
//  
//
//  Created by Stars Momodu on 31/05/2022.
//

import Foundation

public struct Folder: PathRepresentable, Hashable, Equatable {
    public let path: String
    
    public init(_ path: String) {
        var cleanPath = path
        if cleanPath.last == "/", cleanPath != "/" {
            cleanPath.removeLast()
        }
        self.path = cleanPath
    }
    
    public var folderName: String {
        return name.isEmpty ? "/" : name
    }
    
    /// Get a file contained in this folder
    public func file(_ relativePath: String) -> File {
        let divider = self.path.last == "/" || relativePath.first == "/" ? "" : "/"
        return File(path + divider + relativePath)
    }
    
    /// Get a folder contained in this folder
    public func folder(_ relativePath: String) -> Folder {
        let divider = self.path.last == "/" || relativePath.first == "/" ? "" : "/"
        return Folder(path + divider + relativePath)
    }
}

extension Folder: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: Self.StringLiteralType) {
        self.init(value)
    }
}

extension Folder: Comparable {
    public static func < (lhs: Folder, rhs: Folder) -> Bool {
        return lhs.path < rhs.path
    }
}
