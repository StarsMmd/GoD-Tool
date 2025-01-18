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
    
    public lazy var boolEntries: [EngineEntry<Bool>] = {
        engines.flatMap(\.boolEntries)
    }()
    public lazy var integerEntries: [EngineEntry<Int>] = {
        engines.flatMap(\.integerEntries)
    }()
    public lazy var doubleEntries: [EngineEntry<Double>] = {
        engines.flatMap(\.doubleEntries)
    }()
    public lazy var stringEntries: [EngineEntry<String>] = {
        engines.flatMap(\.stringEntries)
    }()
    public lazy var enumEntries: [EngineEntry<Enum>] = {
        engines.flatMap(\.enumEntries)
    }()
    public lazy var structEntries: [EngineEntry<StructMap>] = {
        engines.flatMap(\.structEntries)
    }()
    
    enum CodingKeys: String, CodingKey {
        case name, description, engines
    }
}
