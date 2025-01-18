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
        var first = self.path
        if first.last == "/" {
            first.removeLast()
        }
        var last = relativePath
        if last.first == "/" {
            last.removeFirst()
        }
        
        return File(first + "/" + last)
    }
    
    /// Get a file contained in this folder
    public func file(_ relativePath: File) -> File {
        file(relativePath.path)
    }
    
    /// Get a folder contained in this folder
    public func folder(_ relativePath: String) -> Folder {
        var first = self.path
        if first.last == "/" {
            first.removeLast()
        }
        var last = relativePath
        if last.first == "/" {
            last.removeFirst()
        }
        
        return Folder(first + "/" + last)
    }
    
    /// Get a folder contained in this folder
    public func folder(_ relativePath: Folder) -> Folder {
        folder(relativePath.path)
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

extension Folder: Codable {
    enum CodingKeys: String, CodingKey {
        case path
    }
}
