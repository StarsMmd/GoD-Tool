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
        let divider = relativePath.first == "/" ? "" : "/"
        return File(path + divider + relativePath)
    }
    
    /// Get a folder contained in this folder
    public func folder(_ relativePath: String) -> Folder {
        let divider = relativePath.first == "/" ? "" : "/"
        return Folder(path + divider + relativePath)
    }
    
    ///  Get all files contained in this directory
    public var files: [File] {
        let filenames = (try? FileManager.default.contentsOfDirectory(atPath: path.isEmpty ? "/" : path)) ?? []
        return filenames.map { self.file($0) }.filter {
            var isDirectory: ObjCBool = false
            _ = FileManager.default.fileExists(atPath: $0.path, isDirectory: &isDirectory)
            return !isDirectory.boolValue
        }
    }
    
    ///  Get all subdirectories contained in this directory
    public var folders: [Folder] {
        let filenames = (try? FileManager.default.contentsOfDirectory(atPath: path.isEmpty ? "/" : path)) ?? []
        return filenames.map { self.folder($0) }.filter {
            var isDirectory: ObjCBool = false
            _ = FileManager.default.fileExists(atPath: $0.path, isDirectory: &isDirectory)
            return isDirectory.boolValue
        }
    }
    
    public func contains(_ item: File) -> Bool {
        return files.contains(item)
    }
    
    public func contains(_ item: Folder) -> Bool {
        return folders.contains(item)
    }
    
    @discardableResult
    public func create() -> Bool {
        if !self.exists {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return false
            }
        }
        return true
    }
    
    /// The default documents directory for the user
    public static var documents: Folder {
        Folder(
            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        )
    }
    
    public static var currentWorkingDirectory: Folder {
        Folder (
            FileManager.default.currentDirectoryPath
        )
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
