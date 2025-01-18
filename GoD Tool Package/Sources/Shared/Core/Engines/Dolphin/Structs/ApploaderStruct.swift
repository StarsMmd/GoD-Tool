//
//  ApploaderStruct.swift
//  
//
//  Created by Stars Momodu on 03/06/2024.
//

import Foundation
import Structs

let apploaderHeaderStruct = StructMap(
    name: "Apploader Header",
    wordSize: 4,
    alignmentStyle: .cStyle,
    properties: [
        .string(name: "Date", format: .utf8, length: 10),
        .padding(length: 6),
        .uint32(name: "Entry Point"),
        .uint32(name: "Size"),
        .uint32(name: "Trailer Size"),
        .padding(length: 4)
    ]
)
