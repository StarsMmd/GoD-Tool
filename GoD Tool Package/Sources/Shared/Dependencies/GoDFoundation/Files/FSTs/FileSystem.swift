//
//  OnDiscFST.swift
//  
//
//  Created by Stars Momodu on 02/06/2024.
//

import Foundation

public class FileSystem: FileSystemTree {
    
    public static let shared = FileSystem()
    private init() {}
    
    public func inspectFile(at path: File) -> FileMetaData? {
        let fm = FileManager.default
        let filePath = path.path
        
        let exists = fm.fileExists(atPath: filePath)
        guard exists else { return nil }
        
        let name = path.name
        let type = name.fileExtension
        
        let attributes = try? fm.attributesOfItem(atPath: filePath)
        let size: Int? = attributes?[.size] as? Int
        
        return .init(
            filename: name,
            filetype: type,
            filesize: size,
            notes: nil
        )
    }
    
    public func readFile(at path: File) -> GoDData? {
        guard let data = try? Data(contentsOf: path.url) else  {
            return nil
        }
        return GoDData(data: data)
    }
    
    @discardableResult
    public func moveFile(at path: File, to newPath: File, overwrite: Bool) -> Bool {
        guard let parentFolder = newPath.parentFolder else {
            return false
        }
        do {
            if !parentFolder.exists {
                createFolder(at: parentFolder, overwrite: overwrite)
            }
            try FileManager.default.moveItem(atPath: path.path, toPath: newPath.path)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func writeFile(_ file: GoDData, at path: File, overwrite: Bool) -> Bool {
        guard let parentFolder = path.parentFolder else { return false }
        if !parentFolder.exists {
            createFolder(at: parentFolder, overwrite: overwrite)
        }
        guard !itemExists(at: path) || overwrite else { return false }
        do {
            try file.data.write(to: path.url)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func deleteFile(at path: File) -> Bool {
        let fm = FileManager.default
        do {
            try fm.removeItem(at: path.url)
            return true
        } catch {
            return false
        }
    }
    
    public func inspectFolder(at path: Folder) -> FolderMetaData? {
        let fm = FileManager.default
        guard let paths = try? fm.contentsOfDirectory(atPath: path.path) else {
            return nil
        }
        let folder = path
        let contents = paths.map { path in
            var isDirectory: ObjCBool = false
            _ = fm.fileExists(atPath: path, isDirectory: &isDirectory)
            if isDirectory.boolValue {
                let folderPath = folder.folder(path)
                return FolderMetaData.Item.folder(path: folderPath)
            } else {
                let filePath = folder.file(path)
                return FolderMetaData.Item.file(path: filePath)
            }
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
        guard let parentFolder = newPath.parentFolder else {
            return false
        }
        do {
            if !parentFolder.exists {
                createFolder(at: parentFolder, overwrite: overwrite)
            }
            guard !itemExists(at: path) || overwrite else { return false }
            try FileManager.default.moveItem(atPath: path.path, toPath: newPath.path)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func createFolder(at path: Folder, overwrite: Bool) -> Bool {
        guard !itemExists(at: path) || overwrite else { return false }
        let fm = FileManager.default
        do {
            try fm.createDirectory(atPath: path.path, withIntermediateDirectories: true)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func deleteFolder(at path: Folder) -> Bool {
        guard itemExists(at: path) else { return true }
        let fm = FileManager.default
        do {
            try fm.removeItem(atPath: path.path)
            return true
        } catch {
            return false
        }
    }
    
    public func pathForResource(_ filename: String, bundle: Bundle) -> File? {
        guard let url = bundle.url(forResource: filename.withoutExtension, withExtension: filename.fileExtension) else {
            return nil
        }
        return File(url.path)
    }
    
    public var documents: Folder {
        Folder(
            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        )
    }
    
    public var currentWorkingDirectory: Folder {
        Folder (
            FileManager.default.currentDirectoryPath
        )
    }
    
    public func write(_ fst: FileSystemTree, at path: Folder, overwrite: Bool) {
        func write(_ folderInfo: FolderMetaData, to folder: Folder) {
            folderInfo.contents.forEach { item in
                switch item {
                case .file(let file):
                    if let fileData = fst.readFile(at: file) {
                        self.writeFile(fileData, at: folder.file(file.fileName), overwrite: overwrite)
                    }
                case .folder(let path):
                    if let folderData = fst.inspectFolder(at: path) {
                        let subfolder = folder.folder(path.folderName)
                        self.createFolder(at: subfolder, overwrite: false)
                        write(folderData, to: subfolder)
                    }
                }
            }
        }
        write(fst.root, to: path)
    }
}
