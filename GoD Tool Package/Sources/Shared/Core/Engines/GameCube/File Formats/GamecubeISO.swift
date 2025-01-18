//
//  GamecubeISO.swift
//  
//
//  Created by Stars Momodu on 17/05/2024.
//

import GoDFoundation
import GoDEngine
import Dolphin
import Structs

public final class GamecubeISO: FileSystemTree, FileFormat {
    public static let formatName = "Gamecube.iso"
    
    private let engine: Engine
    private let fst = InMemoryFST()
    
    public var fstManifest: DolphinFST {
        DolphinFST(fileSystem: self, root: filesFolder)
    }
    
    public func inspectFile(at path: File) -> FileMetaData? {
        fst.inspectFile(at: path)
    }
    
    public func readFile(at path: File) -> GoDData? {
        fst.readFile(at: path)
    }
    
    public func moveFile(at path: File, to newPath: File, overwrite: Bool) -> Bool {
        fst.moveFile(at: path, to: newPath, overwrite: overwrite)
    }
    
    public func writeFile(_ file: GoDData, at path: File, overwrite: Bool) -> Bool {
        file.setByteOrder(.big)
        return fst.writeFile(file, at: path, overwrite: overwrite)
    }
    
    public func deleteFile(at path: File) -> Bool {
        fst.deleteFile(at: path)
    }
    
    public func inspectFolder(at path: Folder) -> FolderMetaData? {
        fst.inspectFolder(at: path)
    }
    
    public func moveFolder(at path: Folder, to newPath: Folder, overwrite: Bool) -> Bool {
        fst.moveFolder(at: path, to: newPath, overwrite: overwrite)
    }
    
    public func createFolder(at path: Folder, overwrite: Bool) -> Bool {
        fst.createFolder(at: path, overwrite: overwrite)
    }
    
    public func deleteFolder(at path: Folder) -> Bool {
        fst.deleteFolder(at: path)
    }
    
    public init(data: GoDData, engine: Engine) throws {
        self.engine = engine
        data.setByteOrder(.big)
        
        // Create root folders
        fst.createFolder(at: systemFolder, overwrite: true)
        fst.createFolder(at: filesFolder, overwrite: true)
        
        // Get boot.bin
        let bootDataStruct: StructDefinition = try engine.get("Boot Data Struct")
        let bootDataOffset: Int = try engine.get("boot data offset")
        let bootFile: String = try engine.get("boot path")
        guard let bootData = data.read(struct: bootDataStruct, atAddress: bootDataOffset) else {
            throw Self.invalidFileError
        }
        
        fst.writeFile(bootData.data, at: File(bootFile), overwrite: true)
        
        // Get fst.bin
        let fstOffset: Int = try bootData.fstOffset
        let fstSize: Int = try bootData.fstSize
        let fstFile: String = try engine.get("fst path")
        guard let fstData = data.read(atAddress: fstOffset, length: fstSize) else {
            throw Self.invalidFileError
        }
        
        fst.writeFile(fstData, at: File(fstFile), overwrite: true)
        
        // Get main.dol
        let dolOffset: Int = try bootData.mainExecutableOffset
        let dolHeaderStruct: StructDefinition = try engine.get("Dol Header Struct")
        guard let dolHeader = data.read(struct: dolHeaderStruct, atAddress: dolOffset) else {
            throw Self.invalidFileError
        }
        let textSectionsSizes: [UInt32] = try dolHeader.textSectionsSizes
        let dataSectionsSizes: [UInt32] = try dolHeader.dataSectionsSizes
        
        let textSizes = textSectionsSizes.map { $0.asInt }
        let dataSizes = dataSectionsSizes.map { $0.asInt }
        let dolSize = dolHeader.length + textSizes.reduce(0, +) + dataSizes.reduce(0, +)
        
        guard let dolData = data.read(atAddress: dolOffset, length: dolSize) else {
            throw Self.invalidFileError
        }
        let dolFile: String = try engine.get("executable path")
        
        fst.writeFile(dolData, at: File(dolFile), overwrite: true)
        
        // Get bi2.bin
        let bi2DataStruct: StructDefinition = try engine.get("Bi2 Struct")
        let bi2DataOffset: Int = try engine.get("bi2 data offset")
        let bi2File: String = try engine.get("bi2 path")
        guard let bi2Data = data.read(struct: bi2DataStruct, atAddress: bi2DataOffset) else {
            throw Self.invalidFileError
        }
        
        fst.writeFile(bi2Data.data, at: File(bi2File), overwrite: true)
        
        // Get apploader.img
        let apploaderHeaderStruct: StructDefinition = try engine.get("Apploader Header Struct")
        let apploaderOffset: Int = try engine.get("apploader offset")
        guard let apploaderHeader = data.read(struct: apploaderHeaderStruct, atAddress: apploaderOffset) else {
            throw Self.invalidFileError
        }
        let appSize: Int = try apploaderHeader.size
        let trailerSize: Int = try apploaderHeader.trailerSize
        let apploaderFile: String = try engine.get("apploader path")
        
        let apploaderSize = apploaderHeader.length + appSize + trailerSize
        guard let apploader = data.read(atAddress: apploaderOffset, length: apploaderSize) else {
            throw Self.invalidFileError
        }
        
        fst.writeFile(apploader, at: File(apploaderFile), overwrite: true)
        
        let userSectionOffset: Int = try bootData.userDataOffset
        let fstManifest = try DolphinFST(tocData: fstData, userSectionOffset: userSectionOffset, engine: engine)
        
        fstManifest.folders.sorted().forEach { folder in
            fst.createFolder(at: folder, overwrite: true)
        }
        fstManifest.files.keys.sorted().forEach { file in
            guard let (offset, size) = fstManifest.files[file],
                  let fileData = data.read(atAddress: offset + userSectionOffset, length: size)  else { return }
            fst.writeFile(fileData, at: file, overwrite: true)
        }
    }
    
    public init(fst: FileSystemTree, rootFolder: Folder, engine: Engine) {
        self.engine = engine
        importFST(fst, from: rootFolder, to: Folder("/"), overwrite: true)
    }
    
    public var data: GoDData {
        get throws {
            let isoData = GoDData(length: 0, byteOrder: .big)
            
            // Get boot.bin
            let bootFile = File(try engine.get("boot path"))
            let bootDataStruct: StructDefinition = try engine.get("Boot Data Struct")
            guard let bootData = readFile(at: bootFile),
                  let bootStruct = bootData.read(struct: bootDataStruct, atAddress: 0) else {
                throw Self.failedToEncodeError(target: ".iso")
            }
            
            // Set bi2.bin
            let bi2DataStruct: StructDefinition = try engine.get("Bi2 Struct")
            let bi2File = File(try engine.get("bi2 path"))
            guard let bi2Data = readFile(at: bi2File),
                  let bi2Struct = bi2Data.read(struct: bi2DataStruct, atAddress: 0) else {
                throw Self.failedToEncodeError(target: ".iso")
            }
            
            let bi2DataOffset: Int = try engine.get("bi2 data offset")
            isoData.write(struct: bi2Struct, atAddress: bi2DataOffset)
            
            // Set apploader.img
            let apploaderFile = File(try engine.get("apploader path"))
            guard let apploaderData = readFile(at: apploaderFile) else {
                throw Self.failedToEncodeError(target: ".iso")
            }
            
            let apploaderOffset: Int = try engine.get("apploader offset")
            isoData.write(apploaderData, atAddress: apploaderOffset)
            
            // Set main.dol
            var dolOffset = apploaderOffset + apploaderData.length
            let dolAlignment: Int = try engine.get("dol offset alignment")
            while dolOffset % dolAlignment != 0 { dolOffset += 1 }
            bootStruct.mainExecutableOffset = dolOffset
            
            let dolFile = File(try engine.get("executable path"))
            guard let dolData = readFile(at: dolFile) else {
                throw Self.failedToEncodeError(target: ".iso")
            }
            isoData.write(dolData, atAddress: dolOffset)
            
            // Set fst.bin
            var fstOffset = dolOffset + dolData.length
            let fstAlignment: Int = try engine.get("fst offset alignment")
            while fstOffset % fstAlignment != 0 { fstOffset += 1 }
            bootStruct.fstOffset = fstOffset
            
            let fstSize = fstManifest.tocDataLength
            bootStruct.fstSize = fstSize
            bootStruct.maxFstSize = fstSize
            
            var userOffset = fstOffset + fstSize + 0x20
            let userAlignment: Int = try engine.get("user offset alignment")
            while userOffset % userAlignment != 0 { userOffset += 1 }
            bootStruct.userDataOffset = userOffset
            
            let fstData = try fstManifest.tocData(userOffset: userOffset, engine: engine)
            
            isoData.write(fstData, atAddress: fstOffset)
            
            // Set user files
            let userData = GoDData(byteOrder: .big)
            try fstManifest.files
                .sorted(by: { item1, item2 in
                    item1.value.offsetInUserSection < item2.value.offsetInUserSection
                })
                .forEach { (file, value) in
                    let offset = value.offsetInUserSection
                    guard let fileData = fst.readFile(at: file) else {
                        throw Self.failedToEncodeError(target: ".iso")
                    }
                    userData.write(fileData, atAddress: offset)
                }
            let alignment = 0x10 - (userData.length % 0x10)
            userData.append(.init(length: alignment))
            bootStruct.userDataLength = userData.length
            
            isoData.write(userData, atAddress: userOffset)
            
            // Write boot.bin
            let bootDataOffset: Int = try engine.get("boot data offset")
            isoData.write(struct: bootStruct, atAddress: bootDataOffset)
            
            return isoData
        }
    }
    
    public var filesFolder: Folder {
        Folder((try? engine.get("files folder path")) ?? "/files")
    }
    
    public var systemFolder: Folder {
        Folder((try? engine.get("system folder path")) ?? "/sys")
    }
}
