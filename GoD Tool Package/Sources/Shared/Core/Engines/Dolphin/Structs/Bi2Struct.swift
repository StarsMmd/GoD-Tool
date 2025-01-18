//
//  Bi2Struct.swift
//  
//
//  Created by Stars Momodu on 03/06/2024.
//

import Foundation
import Structs

let bi2Struct = StructMap(
    name: "Bi2 Data",
    wordSize: 4,
    alignmentStyle: .cStyle,
    properties: [
        .uint32(name: "Debug Monitor Size"),
        .uint32(name: "Simulated Memory Size"),
        .uint32(name: "Argument Offset"),
        .uint32(name: "Debug Flag"),
        .uint32(name: "Track Location"),
        .uint32(name: "Track Size"),
        .uint32(name: "Country Code"),
        .uint32(name: "Unknown"),
        .padding(length: 0x1FE0)
    ],
    description: "this is loaded to the Address in 0x800000f4 when a disc is initialized by the IPL. https://hitmen.c02.at/files/yagcd/yagcd/chap13.html"
)
