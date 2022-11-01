//
//  File.swift
//  
//
//  Created by Stars Momodu on 17/09/2022.
//

import Foundation
import Structs

let ISOMetaDataStruct = StructDefinition(
    name: "ISO MetaData",
    wordSize: 4,
    alignmentStyle: .cStyle,
    properties: [

    ]
)

let ISOLayoutStruct = StructDefinition(
    name: "ISO Layout",
    wordSize: 4,
    alignmentStyle: .cStyle,
    properties: [
        .uint32(name: "Unknown 1"),
        .uint32(name: "Unknown 2"),
        .uint32(name: "DOL Start Offset"),
        .uint32(name: "TOC Start Offset"),
        .uint32(name: "TOC File Size"),
        .uint32(name: "TOC Max File Size")
    ]
)


