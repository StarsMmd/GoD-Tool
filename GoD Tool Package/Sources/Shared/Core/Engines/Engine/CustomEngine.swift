//
//  CustomEngine.swift
//  
//
//  Created by Stars Momodu on 07/06/2024.
//

import Foundation
import Structs

public class CustomEngine: Engine, Codable {
    public let name: String
    public let description: String
    public let boolEntries: [EngineEntry<Bool>]
    public let integerEntries: [EngineEntry<Int>]
    public let doubleEntries: [EngineEntry<Double>]
    public let stringEntries: [EngineEntry<String>]
    public let enumEntries: [EngineEntry<Enum>]
    public let structEntries: [EngineEntry<StructMap>]
    
    public init(
        name: String,
        description: String,
        boolEntries: [EngineEntry<Bool>],
        integerEntries: [EngineEntry<Int>],
        doubleEntries: [EngineEntry<Double>],
        stringEntries: [EngineEntry<String>],
        enumEntries: [EngineEntry<Enum>],
        structEntries: [EngineEntry<StructMap>]
    ) {
        self.name = name
        self.description = description
        self.boolEntries = boolEntries
        self.integerEntries = integerEntries
        self.doubleEntries = doubleEntries
        self.stringEntries = stringEntries
        self.enumEntries = enumEntries
        self.structEntries = structEntries
    }
}
