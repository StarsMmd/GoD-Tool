//
//  GameCubeFST.swift
//  
//
//  Created by Stars Momodu on 01/06/2022.
//

import Foundation
import GoDFoundation
import GoDFiles

fileprivate let kFSTNumberEntriesOffset = 0x8
fileprivate let kFSTEntrySize           = 0xc

//public class GameCubeFST {
//    typealias FileInfo = (file: File, offset: Int, size: Int)
//    
//    public var filesInfo: [FileInfo]
//    
//    public var rawData: GoDData {
//        var entryCount = 0
//        let fstData: GoDData = ""
//        let stringTable: GoDData = ""
//        
//        for entry in filesInfo.sorted(by: { info1, info2 in
//            info1.file.path < info2.file.path
//        }) {
//            entryCount += 1
//            if entry.file.parentFolder
//        }
//    }
//    
//    public init(filesInfo: [FileInfo]) {
//        self.rootDirectoryName = rootDirectoryName
//        self.filesInfo = filesInfo
//    }
//    
//    public func init?(data: GoDData) {
//        guard let rootDirectoryIsValid: Bool = data.readValue(atAddress: 0),
//        let entryCount: Int = data.readValue(atAddress: kFSTNumberEntriesOffset) else {
//            return nil
//        }
//        let stringTableOffset = entryCount * kFSTEntrySize
//        
//        var currentOffset = kFSTEntrySize
//        var currentDirectory: Folder = ""
//        var directoryEndStack = Stack<Int>()
//        
//        while (currentOffset < stringTableOffset) {
//            if currentOffset == directoryEndStack.peek() {
//                directoryEndStack.pop()
//                currentDirectory = currentDirectory.parentFolder
//            }
//            
//            let isDirectory: Bool = data.readValue(atAddress: currentOffset)
//
//            if isDirectory,
//               let nameValue: Int = data.readValue(atAddress: currentOffset) {
//                let nameOffset = nameValue & 0xFFFFFF
//                guard let name = data.readString(atAddress: Int(nameOffset), format: .utf8),
//                      let endOffset: Int = data.readValue(atAddress: currentOffset + 8) else {
//                    return nil
//                }
//                currentDirectory = currentDirectory.folder(name)
//                directoryEndStack.push(endOffset)
//            } else {
//                guard let nameOffset: Int = data.readValue(atAddress: currentOffset),
//                      let fileName = data.readString(atAddress: nameOffset, format: .utf8),
//                      let fileOffset: Int = data.readValue(atAddress: currentOffset + 4)
//                        let fileSize: Int = data.readValue(atAddress: currentOffset + 8)
//                let fileOffset = Int(FSTData.getWordAtOffset(offset + 4))
//                        let fileSize   = Int(FSTData.getWordAtOffset(offset + 8)) else {
//                    return nil
//                }
//                filesInfo.append((file: currentDirectory.file(fileName), offset: fileOffset, size: fileSize))
//            }
//            currentOffset += kFSTEntrySize
//        }
//    }
//}
//
//extension GameCubeFST: DataRepresentable {}
