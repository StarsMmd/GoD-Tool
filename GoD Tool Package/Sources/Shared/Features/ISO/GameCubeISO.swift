//
//  GameCubeISO.swift
//  
//
//  Created by Stars Momodu on 01/06/2022.
//

import Foundation
import GoDFiles
import GoDFoundation

fileprivate let kDOLStartOffsetLocation = 0x420
fileprivate let kFSTStartOffsetLocation = 0x424
fileprivate let kFSTFileSizeLocation    = 0x428
fileprivate let kFSTMaxFileSizeLocation = 0x42C
fileprivate let kISOFirstFileOffsetLocation = 0x434 // The "user data" start offset. Basically all the game specific files
let kISOFilesTotalSizeLocation = 0x438 // The size of the game specific files, so everything after dol and FST

//open class GameCubeISO: ISO {
//    
//    private var dol: GoDData
//    private var fst: GameCubeFST
//    
//    public var allFiles: [File] {
//        return fst.allFileNames.map { File($0) } + ["Start.dol", "fst.bin"]
//    }
//    
//    private init?(data: GoDData) {
//        
//        guard let DOLStart: Int = data.readValue(atAddress: kDOLStartOffsetLocation),
//              let FSTStart: Int = data.readValue(atAddress: kFSTStartOffsetLocation),
//              let FSTSize: Int  = data.readValue(atAddress: kFSTFileSizeLocation),
//              let FSTData = data.read(atAddress: FSTStart, length: FSTSize) else {
//            return nil
//        }
//        fst = GameCubeFST(data: FSTData)
//        
//        let kDolSectionSizesStart = 0x90
//        let kDolSectionSizesCount = 18
//        let kDolHeaderSize = 0x100
//
//        var DOLSize = kDolHeaderSize
//        for i in 0 ..< kDolSectionSizesCount {
//            let offset = DOLStart + (i * 4) + kDolSectionSizesStart
//            DOLSize += data.readValue(atAddress: offset)
//        }
//        guard let dol = data.read(atAddress: DOLStart, length: DOLSize) else {
//            return nil
//        }
//        self.dol = dol
//    }
//}
