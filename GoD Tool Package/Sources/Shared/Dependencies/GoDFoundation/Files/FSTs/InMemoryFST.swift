//
//  InMemoryFST.swift
//  
//
//  Created by Stars Momodu on 02/06/2024.
//

import Foundation

public class InMemoryFST: FileSystemTree {
    private enum Node {
        case file(GoDData)
        case folder
    }
    
    private var fst = [String: Node]()
    
    public init() {}
    
    public func inspectFile(at path: File) -> FileMetaData? {
        guard let node = fst[path.path],
              case .file(let data) = node else {
            return nil
        }
        return .init(
            filename: path.fileName,
            filetype: path.fileType,
            filesize: data.length,
            notes: nil
        )
    }
    
    public func readFile(at path: File) -> GoDData? {
        guard let node = fst[path.path],
              case .file(let data) = node else {
            return nil
        }
        return data
    }
    
    @discardableResult
    public func moveFile(at path: File, to newPath: File, overwrite: Bool) -> Bool {
        guard !itemExists(at: newPath) || overwrite else { return false }
        guard let node = fst[path.path], case .file = node else { return false }
        fst[newPath.path] = node
        fst[path.path] = nil
        return true
    }
    
    @discardableResult
    public func writeFile(_ file: GoDData, at path: File, overwrite: Bool) -> Bool {
        guard !itemExists(at: path) || overwrite else { return false }
        fst[path.path] = .file(file)
        return true
    }
    
    @discardableResult
    public func deleteFile(at path: File) -> Bool {
        fst[path.path] = nil
        return true
    }
    
    public func inspectFolder(at path: Folder) -> FolderMetaData? {
        let keys = fst.keys.filter { $0.startsWith(path.path) && $0 != path.path }
        var totalSize = 0
        let contents: [FolderMetaData.Item] = keys.compactMap { subpath in
            let file = File(subpath)
            let folder = Folder(subpath)
            if let metaData = inspectFile(at: file) {
                totalSize += metaData.filesize ?? 0
                guard file.parentFolder == path else { return nil }
                return .file(path: file)
            } else if let _ = inspectFolder(at: folder) {
                guard folder.parentFolder == path else { return nil }
                return .folder(path: folder)
            }
            return nil
        }
        return .init(
            name: path.folderName,
            contents: contents,
            size: nil,
            notes: nil
        )
    }
    
    @discardableResult
    public func moveFolder(at path: Folder, to newPath: Folder, overwrite: Bool) -> Bool {
        guard !itemExists(at: newPath) || overwrite else { return false }
        guard let node = fst[path.path], case .folder = node else { return false }
        fst[newPath.path] = node
        fst[path.path] = nil
        return true
    }
    
    @discardableResult
    public func createFolder(at path: Folder, overwrite: Bool) -> Bool {
        guard !itemExists(at: path) || overwrite else { return false }
        fst[path.path] = .folder
        return true
    }
    
    @discardableResult
    public func deleteFolder(at path: Folder) -> Bool {
        fst[path.path] = nil
        let keys = fst.keys.filter { $0.startsWith(path.path) }
        keys.forEach { subpath in
            fst[subpath] = nil
        }
        return true
    }
}
