//
//  main.swift
//  
//
//  Created by Stars Momodu on 04/06/2024.
//

import GoDFoundation
import Structs
import GameCube
import Dolphin

do {
    let engine = CombinedEngine(name: "Colosseum Project", description: "", engines: [
        GameCube.engine,
        Dolphin.engine
    ])
    
    let disc = FileSystem.shared
    let documents = disc.documents
    let godToolFolder = documents.folder("/GoD Tool")
    let coloFile = godToolFolder.file("XD.iso")
    let isoData = disc.readFile(at: coloFile)!
    isoData.setByteOrder(.big)
    
    let iso = try GamecubeISO(data: isoData, engine: engine)
    let dumpFolder = godToolFolder.folder("test dump")
    
    disc.write(iso, at: dumpFolder, overwrite: true)
    
    let reconstructedISO = try iso.data
    let newISOFile = dumpFolder.file("new.iso")
    disc.writeFile(reconstructedISO, at: newISOFile, overwrite: true)
    
} catch let error {
    print(error)
}

