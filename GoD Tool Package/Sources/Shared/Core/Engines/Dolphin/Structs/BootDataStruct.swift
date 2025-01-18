//
//  BootDataStruct.swift
//  
//
//  Created by Stars Momodu on 03/06/2024.
//

import Foundation
import Structs

let bootDataStruct = StructMap(
    name: "ISO Boot Data",
    wordSize: 4,
    alignmentStyle: .cStyle,
    properties: [
        .string(name: "Game ID", format: .utf8, length: 4),
        .string(name: "Maker Code", format: .utf8, length: 2),
        .uint8(name: "Disc Number"),
        .uint8(name: "Disc Version"),
        .uint8(name: "Audio Streaming"),
        .uint8(name: "Stream Buffer Size"),
        .padding(length: 0x12),
        .uint32(name: "DVD Magic Word"),
        .string(name: "Game Title", format: .utf8, length: 0x3e0),
        .uint32(name: "Debug Monitor Offset"),
        .uint32(name: "Debug Monitor RAM Address"),
        .padding(length: 0x18),
        .uint32(name: "main executable offset"),
        .uint32(name: "fst offset"),
        .uint32(name: "fst size"),
        .uint32(name: "max fst size", description: "the Max Fst.bin size is the same as the Fst.bin size in most cases. It can be different for 2 disc games though where the other disc has a larger fst.bin. Fst.bin size is always the size of the fst.bin on the same disc."),
        .uint32(name: "User Data RAM Address"),
        .uint32(name: "User Data Offset"),
        .uint32(name: "User Data Length"),
        .padding(length: 4)
    ]
)
