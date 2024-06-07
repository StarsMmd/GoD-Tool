//
//  FST.swift
//  
//
//  Created by Stars Momodu on 04/06/2024.
//

import GoDFoundation
import GoDEngine
import Structs

public class DolphinFST: FileFormat {
    public static let formatName = ".toc"
    
    public var files = [File: (offsetInUserSection: Int, size: Int)]()
    public var folders = [Folder]()
    
    public init(tocData: GoDData, userSectionOffset: Int, engine: Engine) throws {
        let rootStruct: StructDefinition = try engine.get("FST Root Struct")
        let fileStruct: StructDefinition = try engine.get("FST File Struct")
        let folderStruct: StructDefinition = try engine.get("FST Folder Struct")
        guard let root = tocData.read(struct: rootStruct, atAddress: 0) else {
            throw Self.invalidFileError
        }
        let entryCount: Int = try root.entryCount
        
        let entrySize = 12
        let stringTableOffset = entryCount * entrySize
        
        func getString(_ offset: Int) -> String? {
            tocData.readString(atAddress: stringTableOffset + offset, format: .utf8)
        }
        
        var currentFolder = Folder(try engine.get("files folder path"))
        var subfolderEndIndexes = [Int]()
        for index in 1 ..< entryCount {
            if index == subfolderEndIndexes.last {
                subfolderEndIndexes.removeLast()
                currentFolder = currentFolder.parentFolder ?? currentFolder
            }
            let entryOffset = index * entrySize
            let isDirectory: Bool = tocData.readSafely(atAddress: entryOffset)
            if isDirectory {
                guard let entry = tocData.read(struct: folderStruct, atAddress: entryOffset) else {
                    throw Self.invalidFileError
                }
                let nameOffset: Int = try entry.nameOffset
                let endIndex: Int = try entry.nextEntry
                guard let folderName = getString(nameOffset) else {
                    throw Self.invalidFileError
                }
                currentFolder = currentFolder.folder(folderName)
                folders.append(currentFolder)
                subfolderEndIndexes.append(endIndex)
                
            } else {
                guard let entry = tocData.read(struct: fileStruct, atAddress: entryOffset) else {
                    throw Self.invalidFileError
                }
                let nameOffset: Int = try entry.nameOffset
                let fileOffset: Int = try entry.fileOffset
                let fileSize: Int = try entry.fileSize
                guard let filename = getString(nameOffset) else {
                    throw Self.invalidFileError
                }
                let file = currentFolder.file(filename)
                files[file] = (fileOffset - userSectionOffset, fileSize)
                
            }
        }
    }
    
    public init(fileSystem: FileSystemTree, root: Folder = Folder("/")) {
        var currentOffset = 0
        func add(_ item: FolderMetaData.Item) {
            switch item {
            case .file(let file):
                guard let data = fileSystem.readFile(at: file) else { return }
                files[file] = (currentOffset, data.length)
                currentOffset += data.length
            case .folder(let folder):
                guard let contents = fileSystem.inspectFolder(at: folder)?.contents else { return }
                if folder != root {
                    folders.append(folder)
                }
                add(contents)
            }
            
            while currentOffset % 4 != 0 {
                currentOffset += 1
            }
        }
        
        func add(_ items: [FolderMetaData.Item]) {
            items
                .sorted { item1, item2 in
                    item1.path < item2.path
                }
                .forEach { item in
                    add(item)
                }
        }
        
        guard let rootContents = fileSystem.inspectFolder(at: root)?.contents else {
            return
        }
        add(rootContents)
    }
    
    public var tocDataEntryCount: Int {
        files.keys.count + folders.count + 1
    }
    
    public var tocDataLength: Int {
            let entrySize = 12
            return tocDataEntryCount * entrySize + stringTableLength
    }
    
    public func tocData(userOffset: Int, engine: Engine) throws -> GoDData {
        let tocData = GoDData(length: tocDataLength, byteOrder: .big)
        
        let entrySize = 12
        let rootStruct: StructDefinition = try engine.get("FST Root Struct")
        let fileStruct: StructDefinition = try engine.get("FST File Struct")
        let folderStruct: StructDefinition = try engine.get("FST Folder Struct")
        
        let rootData = StructData(definition: rootStruct, byteOrder: .big)
        rootData.isDirectory = true
        rootData.entryCount = tocDataEntryCount
        tocData.write(struct: rootData, atAddress: 0)
        
        let stringTable = GoDData()
        
        var currentIndex = 1
        let entryPaths = ["/"] + (files.keys.map(\.path) + folders.map(\.path)).sorted(by: {
            $0.uppercased() < $1.uppercased()
        })
        var folderIndexes = [Folder: Int]()
        while currentIndex < tocDataEntryCount {
            let currentOffset = currentIndex * entrySize
            let currentPath = entryPaths[currentIndex]
            let isFile = files[File(currentPath)] != nil
            if isFile {
                let file = File(currentPath)
                let nameOffset = stringTable.length
                stringTable.appendString(file.fileName, format: .utf8, includeTerminator: true)
                guard let (offset, size) = files[file] else {
                    throw Self.failedToEncodeError(target: ".iso")
                }
                let fullOffset = offset + userOffset
                
                let fileData = StructData(definition: fileStruct, byteOrder: .big)
                fileData.isDirectory = false
                fileData.nameOffset = nameOffset
                fileData.fileOffset = fullOffset
                fileData.fileSize = size
                tocData.write(struct: fileData, atAddress: currentOffset)
            } else {
                let folder = Folder(currentPath)
                let nameOffset = stringTable.length
                stringTable.appendString(folder.folderName, format: .utf8, includeTerminator: true)
                let parentFolder = folder.parentFolder ?? Folder("/")
                let parentIndex = folderIndexes[parentFolder] ?? 0
                
                let folderData = StructData(definition: folderStruct, byteOrder: .big)
                folderData.isDirectory = true
                folderData.nameOffset = nameOffset
                folderData.parentEntry = parentIndex
                folderData.nextEntry = currentIndex + entryCount(for: folder) + 1
                tocData.write(struct: folderData, atAddress: currentOffset)
                folderIndexes[folder] = currentIndex
            }
            currentIndex += 1
        }
        
        let stringTableOffset = tocDataEntryCount * entrySize
        tocData.write(stringTable, atAddress: stringTableOffset)
        
        return tocData
    }
    
    private func entryCount(for folder: Folder) -> Int {
        let searchPath = folder.path + (folder.path.last == "/" ? "" : "/")
        return files.keys
            .filter { $0.path.startsWith(searchPath) }
            .count
    }
    
    private var stringTableLength: Int {
        (files.keys.map(\.fileName) + folders.map(\.folderName))
            .map { $0.count + 1 } // +1 for null terminator
            .reduce(0, +) // sum
    }
}

extension DolphinFST: CustomStringConvertible {
    public var description: String {
        let paths = files.keys.map(\.path) + folders.map(\.path)
        var result = ""
        paths
            .sorted()
            .forEach { result += $0 + "\n" }
        if result.last == "\n" {
            result.removeLast()
        }
        return result
    }
}
