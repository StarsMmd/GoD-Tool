//
//  Engine.swift
//  
//
//  Created by Stars Momodu on 09/08/2022.
//

import Foundation
import GoDFoundation
import Structs

public protocol Engine: AnyObject {
    var name: String { get }
    var description: String { get }
    
    var boolEntries: [EngineEntry<Bool>] { get }
    var integerEntries: [EngineEntry<Int>] { get }
    var doubleEntries: [EngineEntry<Double>] { get }
    var stringEntries: [EngineEntry<String>] { get }
    var enumEntries: [EngineEntry<EnumDefinition>] { get }
    var structEntries: [EngineEntry<StructDefinition>] { get }
    
    func get(_ name: String) throws -> Bool
    func get(_ name: String) throws -> Int
    func get(_ name: String) throws -> Double
    func get(_ name: String) throws -> String
    func get(_ name: String) throws -> EnumDefinition
    func get(_ name: String) throws -> StructDefinition
}

public extension Engine {
    func get(_ name: String) throws -> Bool {
        for entry in boolEntries {
            if let value = entry.values[name] {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: Bool.self, engine: self)
    }
    func get(_ name: String) throws -> Int {
        for entry in integerEntries {
            if let value = entry.values[name] {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: Int.self, engine: self)
    }
    func get(_ name: String) throws -> Double {
        for entry in doubleEntries {
            if let value = entry.values[name] {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: Double.self, engine: self)
    }
    func get(_ name: String) throws -> String {
        for entry in stringEntries {
            if let value = entry.values[name] {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: String.self, engine: self)
    }

    func get(_ name: String) throws -> EnumDefinition {
        for entry in enumEntries {
            if let value = entry.values[name] {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: EnumDefinition.self, engine: self)
    }
    func get(_ name: String) throws -> StructDefinition {
        for entry in structEntries {
            if let value = entry.values[name] {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: StructDefinition.self, engine: self)
    }
}
