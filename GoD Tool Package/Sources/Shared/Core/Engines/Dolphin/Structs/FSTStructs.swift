//
//  FSTStructs.swift
//  
//
//  Created by Stars Momodu on 04/06/2024.
//

import Foundation
import Structs

let fstRootEntryStruct = StructMap(
    name: "FST Root Entry",
    wordSize: 4,
    alignmentStyle: .cStyle,
    properties: [
        .boolean(name: "Is Directory"),
        .padding(length: 7),
        .uint32(name: "Entry Count")
    ]
)

let fstDirectoryEntryStruct = StructMap(
    name: "FST Directory Entry",
    wordSize: 4,
    alignmentStyle: .cStyle,
    properties: [
        .boolean(name: "Is Directory"),
        .uint24(name: "Name Offset"),
        .uint32(name: "Parent Entry", description: "The index of the entry of the parent directory of this directory"),
        .uint32(name: "Next Entry", description: "The index of the next entry that isn't under this directory")
    ]
)

let fstFileEntryStruct = StructMap(
    name: "FST File Entry",
    wordSize: 4,
    alignmentStyle: .cStyle,
    properties: [
        .boolean(name: "Is Directory"),
        .uint24(name: "Name Offset"),
        .uint32(name: "File Offset"),
        .uint32(name: "File Size")
    ]
)
