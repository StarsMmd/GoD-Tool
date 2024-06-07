//
//  DolStruct.swift
//  
//
//  Created by Stars Momodu on 03/06/2024.
//

import Foundation
import Structs

let dolHeaderStruct = StructDefinition(
    name: "Dol Header",
    wordSize: 4,
    alignmentStyle: .cStyle,
    properties: [
        .array(name: "Text Sections Offsets", count: 7, of: .uint32),
        .array(name: "Data Sections Offsets", count: 11, of: .uint32),
        .array(name: "Text Sections RAM Addresses", count: 7, of: .uint32),
        .array(name: "Data Sections RAM Addresses", count: 11, of: .uint32),
        .array(name: "Text Sections Sizes", count: 7, of: .uint32),
        .array(name: "Data Sections Sizes", count: 11, of: .uint32),
        .uint32(name: "BSS RAM Address"),
        .uint32(name: "BSS Size"),
        .uint32(name: "Entry Point"),
        .padding(length: 0x1c)
    ]
)
