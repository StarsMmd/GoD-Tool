//
//  CombinedEngine.swift
//  
//
//  Created by Stars Momodu on 07/06/2024.
//

import Foundation
import Structs

public class CombinedEngine: Engine, Codable {
    public let name: String
    public let description: String
    
    private let engines: [CustomEngine]
    
    public init(name: String, description: String, engines: [CustomEngine]) {
        self.name = name
        self.description = description
        self.engines = engines
    }
    
    public var boolEntries: [EngineEntry<Bool>] {
        engines.flatMap(\.boolEntries)
    }
    public var integerEntries: [EngineEntry<Int>] {
        engines.flatMap(\.integerEntries)
    }
    public var doubleEntries: [EngineEntry<Double>] {
        engines.flatMap(\.doubleEntries)
    }
    public var stringEntries: [EngineEntry<String>] {
        engines.flatMap(\.stringEntries)
    }
    public var enumEntries: [EngineEntry<EnumDefinition>] {
        engines.flatMap(\.enumEntries)
    }
    public var structEntries: [EngineEntry<StructDefinition>] {
        engines.flatMap(\.structEntries)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, description, engines
    }
}
