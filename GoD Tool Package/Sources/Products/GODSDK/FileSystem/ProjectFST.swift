//
//  File.swift
//  
//
//  Created by Stars Momodu on 09/06/2024.
//

import GoDFoundation

final class ProjectFST: FileSystemTree {
    let rootFolder: Folder
    
    init(rootFolder: Folder) {
        self.rootFolder = rootFolder
    }
    
    func inspectFile(at path: File) -> FileMetaData? {
        FileSystem.shared.inspectFile(at: projectPath(path))
    }
    
    func readFile(at path: File) -> GoDData? {
        FileSystem.shared.readFile(at: projectPath(path))
    }
    
    func moveFile(at path: File, to newPath: File, overwrite: Bool) -> Bool {
        FileSystem.shared.moveFile(at: projectPath(path), to: projectPath(newPath), overwrite: overwrite)
    }
    
    func writeFile(_ file: GoDData, at path: File, overwrite: Bool) -> Bool {
        FileSystem.shared.writeFile(file, at: projectPath(path), overwrite: overwrite)
    }
    
    func deleteFile(at path: File) -> Bool {
        FileSystem.shared.deleteFile(at: projectPath(path))
    }
    
    func inspectFolder(at path: Folder) -> FolderMetaData? {
        FileSystem.shared.inspectFolder(at: projectPath(path))
    }
    
    func moveFolder(at path: Folder, to newPath: Folder, overwrite: Bool) -> Bool {
        FileSystem.shared.moveFolder(at: projectPath(path), to: projectPath(newPath), overwrite: overwrite)
    }
    
    func createFolder(at path: Folder, overwrite: Bool) -> Bool {
        FileSystem.shared.createFolder(at: projectPath(path), overwrite: overwrite)
    }
    
    func deleteFolder(at path: Folder) -> Bool {
        FileSystem.shared.deleteFolder(at: projectPath(path))
    }
    
    private func projectPath(_ subpath: File) -> File {
        rootFolder.file(subpath)
    }
    
    private func projectPath(_ subpath: Folder) -> Folder {
        rootFolder.folder(subpath)
    }
}
