//
//  ColosseumXDDumpOperation.swift
//  
//
//  Created by Stars Momodu on 28/08/2024.
//

import GoDFoundation
import GoDEngine

extension Gamecube {
    private enum ProjectFolders {
        static let assetsFolder = Folder("/Assets")
        
        static let audioFolder = assetsFolder.folder("/Sounds")
        static let criesFolder = audioFolder.folder("/pokemon_cries")
        static let soundFontsFolder = audioFolder.folder("/sound_fonts")
        static let sequencedFolder = audioFolder.folder("/sequenced")
        static let streamedFolder = audioFolder.folder("/streamed")
        
        static let modelsFolder = assetsFolder.folder("/Models")
        static let datFolder = modelsFolder.folder("/characters-and-objects")
        static let pkxFolder = modelsFolder.folder("/battle_models")
        static let wzxFolder = modelsFolder.folder("/effects")
        static let camFolder = modelsFolder.folder("/cameras")
        
        static let mapsFolder = modelsFolder.folder("/Maps")
        static let rdatFolder = mapsFolder.folder("/models")
        static let ccdFolder = mapsFolder.folder("/collision")
        
        static let imagesFolder = assetsFolder.folder("/Images")
        static let pokemonFolder = imagesFolder.folder("/pokemon")
        static let facesFolder = pokemonFolder.folder("/faces")
        static let bodiesFolder = pokemonFolder.folder("/pc-box")
        static let dancerFolder = pokemonFolder.folder("/purify-chamber")
        static let menusFolder = imagesFolder.folder("/menus")
        
        static let flashFolder = assetsFolder.folder("/Flash-menus") // gsw
        static let videosFolder = assetsFolder.folder("/Videos") // thp
        
        static let dialogueFolder = assetsFolder.folder("/Text")
        static let messagesFolder = dialogueFolder.folder("/messages")
        static let fontsFolder = dialogueFolder.folder("/fonts")
        
        static let miscFolder = assetsFolder.folder("/Misc")
        
        static let sourcesFolder = Folder("/Data")
        
        static let fsysFolder = sourcesFolder.folder("/Archives") // fsys metadata
        static let mapScriptsFolder = sourcesFolder.folder("/Maps")
        static let dataTablesFolder = sourcesFolder.folder("/Data-tables")
        
        static let allFolders = [
            assetsFolder,
            audioFolder, criesFolder, soundFontsFolder, sequencedFolder, streamedFolder,
            modelsFolder, datFolder, pkxFolder, wzxFolder, camFolder,
            mapsFolder, rdatFolder, ccdFolder,
            imagesFolder, pokemonFolder, facesFolder, bodiesFolder, dancerFolder, menusFolder,
            flashFolder, videosFolder,
            dialogueFolder, messagesFolder, fontsFolder,
            miscFolder,
            sourcesFolder,
            fsysFolder, mapScriptsFolder, dataTablesFolder
        ]
    }
    
    static func dumpColosseumXD(
        inputFST: FileSystemTree,
        outputFST: FileSystemTree,
        outputFolder: Folder,
        overwrite: Bool,
        engine: Engine,
        settings: GoddessSettings
    ) throws {
        
        let projectFileSystem = InMemoryFST()
        
        ProjectFolders.allFolders.forEach { folder in
            _ = projectFileSystem.createFolder(at: folder, overwrite: overwrite)
        }
        
        func dump(folder: FolderMetaData) {
            folder.contents.forEach { item in
                switch item {
                case .folder(let path):
                    if let folderInfo = inputFST.inspectFolder(at: path) {
                        dump(folder: folderInfo)
                    }
                case .file(let path):
                    guard let file = inputFST.readFile(at: path) else { return }
                    let fileName = path.fileName
                    
                    switch path.fileType {
                    case "fsys":
                        _ = projectFileSystem.writeFile(
                            file,
                            at: ProjectFolders.fsysFolder.file(fileName),
                            overwrite: overwrite
                        )
                    default:
                        _ = projectFileSystem.writeFile(
                            file,
                            at: ProjectFolders.miscFolder.file(fileName),
                            overwrite: overwrite
                        )
                    }
                
                }
            }
        }
        
        dump(folder: inputFST.root)
        outputFST.importFST(projectFileSystem, from: "/", to: outputFolder, overwrite: overwrite)
    }
    
}
