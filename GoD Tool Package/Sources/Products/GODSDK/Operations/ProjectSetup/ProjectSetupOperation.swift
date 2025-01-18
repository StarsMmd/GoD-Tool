//
//  File.swift
//  
//
//  Created by Stars Momodu on 10/06/2024.
//

import GoDFoundation
import GoDEngine
import Dolphin
import GameCube
import Colosseum
import XD

enum Project {
    static func setup(iso isoInputFile: File?, isoContents root: Folder?) throws {
        guard isoInputFile != nil || root != nil else { return }
        
        let fileSystem = FileSystem.shared
        let projectFileSystem = InMemoryFST()
        
        let buildFolder = Folder("/Build")
        let isoFolder = buildFolder.folder("/ISO")
        let contentsFolder = buildFolder.folder("/Contents")
        let sourceFolder = Folder("/Source")
        let configFolder = Folder("/Config")
        let settingsFolder = Folder("/Settings")
        let enginesFolder = Folder("/Engines")
        let scriptsFolder = Folder("/Scripts")
        
        var gameID: String?
        if let isoInputFile,
           let isoData = fileSystem.readFile(at: isoInputFile) {
            gameID = isoData.readString(atAddress: 0, format: .utf8, maxCharacters: 4)
        }
        
        let coloXDgameIDs = PokemonXD.gameIDs + PokemonColosseum.gameIDs
        let isColoXD = coloXDgameIDs.contains(gameID ?? "")
        
        let projectFolders = [
            buildFolder, isoFolder, contentsFolder,
            configFolder, settingsFolder, enginesFolder, scriptsFolder
        ]
            .conditionalAppend(isColoXD, contents: [sourceFolder])
        projectFolders.forEach { folder in
            projectFileSystem.createFolder(at: folder, overwrite: true)
        }
        
        var projectFolder = Folder("/")
        var isoOutputFile: File!
        
        if let root {
            isoOutputFile = isoFolder.file("build.iso")
            projectFolder = Folder(root.path + " project")
            projectFileSystem.importFST(fileSystem, from: root, to: contentsFolder, overwrite: false)
        }
        
        if let file = isoInputFile {
            isoOutputFile = isoFolder.file(file.fileName)
            projectFolder = Folder(file.path.withoutExtensions + " project")
            guard let data = fileSystem.readFile(at: file) else { return }
            projectFileSystem.writeFile(data, at: isoOutputFile, overwrite: false)
        }
        
        let settings = GoddessSettings.default
        let settingsFile = settingsFolder.file("Settings.json")
        try projectFileSystem.encodeJSON(settings, to: settingsFile, overwrite: false)
        
        let engines = [GameCube.engine, Dolphin.engine]
        var engineFiles = [File]()
        try engines.forEach { engine in
            let file = enginesFolder.file(engine.name + ".json")
            engineFiles.append(projectFolder.file(file))
            try projectFileSystem.encodeJSON(engine, to: file, overwrite: false)
        }
        
        let gamecubeDiscSize: Int = try GameCube.engine.get("max disc capacity")
        
        let buildConfig = GoddessConfig(
            name: "Build ISO",
            description: "Config for building ISO from Contents folder",
            settingsFile: projectFolder.file(settingsFile),
            operations: [
                .init(
                    operation: .gamecubeBuild(
                        config: .init(
                            engines: engineFiles,
                            operations: [
                                .init(
                                    operation: .buildISO(
                                        fstPath: projectFolder.folder(contentsFolder),
                                        isoPath: projectFolder.file(isoOutputFile),
                                        overwrite: true
                                    ),
                                    enabled: true
                                ),
                                .init(
                                    operation: .fillISO(
                                        isoPath: projectFolder.file(isoOutputFile),
                                        size: gamecubeDiscSize
                                    ),
                                    enabled: false
                                )
                            ]
                        )
                    ),
                    enabled: true
                )
            ]
        )
        let buildConfigFile = configFolder.file("Build-Config.json")
        try projectFileSystem.encodeJSON(buildConfig, to: buildConfigFile, overwrite: false)
        
        let dumpConfig = GoddessConfig(
            name: "Dump ISO",
            description: "Config for dumping ISO files to Contents folder",
            settingsFile: projectFolder.file(settingsFile),
            operations: [
                .init(
                    operation: .gamecubeDump(
                        config: .init(
                            engines: engineFiles,
                            operations: [
                                .init(
                                    operation: .unpackISO(
                                        isoPath: projectFolder.file(isoOutputFile),
                                        fstFolder: projectFolder.folder(contentsFolder),
                                        overwrite: true
                                    ),
                                    enabled: true
                                )
                            ]
                            .conditionalAppend(
                                isColoXD,
                                contents: [
                                    .init(
                                        operation: .dumpXD(
                                            fstFolder: projectFolder.folder(contentsFolder),
                                            outputFolder: projectFolder.folder(sourceFolder),
                                            overwrite: false
                                        ),
                                        enabled: true
                                    )
                                ]
                            )
                        )
                    ),
                    enabled: true
                )
            ]
        )
        let dumpConfigFile = configFolder.file("Dump-Config.json")
        try projectFileSystem.encodeJSON(dumpConfig, to: dumpConfigFile, overwrite: false)
        
        fileSystem.createFolder(at: projectFolder, overwrite: false)
        fileSystem.importFST(projectFileSystem, from: Folder("/"), to: projectFolder, overwrite: false)
        
        if let executablePath = Bundle.main.executablePath {
            [buildConfigFile, dumpConfigFile].forEach { config in
                let script =
                """
                #!/bin/zsh
                \(executablePath.replacingOccurrences(of: " ", with: "\\ ")) \(projectFolder.file(config).path.replacingOccurrences(of: " ", with: "\\ "))
                """
                let file = projectFolder.folder("/Scripts").file(config.fileName.replacingOccurrences(of: "-Config.json", with: ".sh"))
                fileSystem.writeFile(script.data(format: .utf8), at: file, overwrite: false)
                fileSystem.setExecutable(file: file)
            }
            
        }
    }
}
