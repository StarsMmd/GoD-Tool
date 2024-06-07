//
//  FST.swift
//  
//
//  Created by Stars Momodu on 17/05/2024.
//

import Foundation

public struct FileMetaData {
    public let filename: String
    public let filetype: String?
    public let filesize: Int?
    public let notes: String?
}

public struct FolderMetaData {
    public enum Item {
        case file(path: File)
        case folder(path: Folder)
        
        public var path: String {
            switch self {
            case .file(let path): return path.path
            case .folder(let path): return path.path
            }
        }
    }
    
    public let name: String
    public let contents: [Item]
    public let size: Int?
    public let notes: String?
}

public protocol FileSystemTree {
    func inspectFile(at path: File) -> FileMetaData?
    func readFile(at path: File) -> GoDData?
    func moveFile(at path: File, to newPath: File, overwrite: Bool) -> Bool
    func writeFile(_ file: GoDData, at path: File, overwrite: Bool) -> Bool
    func deleteFile(at path: File) -> Bool
    
    func inspectFolder(at path: Folder) -> FolderMetaData?
    func moveFolder(at path: Folder, to newPath: Folder, overwrite: Bool) -> Bool
    func createFolder(at path: Folder, overwrite: Bool) -> Bool
    func deleteFolder(at path: Folder) -> Bool
}

public extension FileSystemTree {
    func itemExists(at path: PathRepresentable) -> Bool {
        if let filePath =  path as? File {
            return inspectFile(at: filePath) != nil
        }
        if let folderPath =  path as? Folder {
            return inspectFolder(at: folderPath) != nil
        }
        return false
    }
    
    @discardableResult
    func rename(file path: File, to newName: String, overwrite: Bool = false) -> Bool {
        guard let newFile = path.parentFolder?.file(newName) else { return false }
        return moveFile(at: path, to: newFile, overwrite: overwrite)
    }
    
    @discardableResult
    func rename(folder path: Folder, to newName: String, overwrite: Bool = false) -> Bool {
        guard let newFolder = path.parentFolder?.folder(newName) else { return false }
        return moveFolder(at: path, to: newFolder, overwrite: overwrite)
    }
    
    var root: FolderMetaData {
        let rootFolder = Folder("/")
        return inspectFolder(at: rootFolder) ?? .init(name: "/", contents: [], size: nil, notes: nil)
    }
}
