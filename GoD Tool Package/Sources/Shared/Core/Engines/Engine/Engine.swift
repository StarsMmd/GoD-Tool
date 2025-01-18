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
    var enumEntries: [EngineEntry<Enum>] { get }
    var structEntries: [EngineEntry<StructMap>] { get }
    
    func get(_ name: String) throws -> Bool
    func get(_ name: String) throws -> Int
    func get(_ name: String) throws -> Double
    func get(_ name: String) throws -> String
    func get(_ name: String) throws -> Enum
    func get(_ name: String) throws -> StructDefinition
}

public extension Engine {
    func get(_ name: String) throws -> Bool {
        for entry in boolEntries {
            if let value = entry.match(name) {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: Bool.self, engine: self)
    }
    func get(_ name: String) throws -> Int {
        for entry in integerEntries {
            if let value = entry.match(name) {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: Int.self, engine: self)
    }
    func get(_ name: String) throws -> Double {
        for entry in doubleEntries {
            if let value = entry.match(name) {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: Double.self, engine: self)
    }
    func get(_ name: String) throws -> String {
        for entry in stringEntries {
            if let value = entry.match(name) {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: String.self, engine: self)
    }

    func get(_ name: String) throws -> Enum {
        for entry in enumEntries {
            if let value = entry.match(name) {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: Enum.self, engine: self)
    }
    func get(_ name: String) throws -> StructMap {
        for entry in structEntries {
            if let value = entry.match(name) {
                return value
            }
        }
        throw EngineError.MissingConfig(key: name, type: StructMap.self, engine: self)
    }
    func get(_ name: String) throws -> StructDefinition {
        for entry in structEntries {
            if let map = entry.values[name] {
                func mapToDefinition(field: StructMap.Property) throws -> StructDefinition.Property {
                    let name = field.name
                    let description = field.description
                    
                    func toProperty(field: StructField) throws -> StructProperty {
                        switch field {
                        case .primitive(let type):
                            return .primitive(type)
                        case .array(let field, let count):
                            let property = try toProperty(field: field)
                            return .array(property, count: count)
                        case .subStruct(let name):
                            let subDef: StructDefinition = try get(name)
                            return .subStruct(subDef)
                        case .enumeration(let name):
                            let def: Enum = try get(name)
                            return .enumeration(def)
                        case .padding(let length):
                            return .padding(length: length)
                        }
                    }
                    let type = try toProperty(field: field.type)
                    return .init(name: name, type: type, description: description)
                }
                let name = map.name
                let wordSize = map.wordSize
                let alignmentStyle = map.alignmentStyle
                let properties = try map.properties.map { try mapToDefinition(field: $0) }
                let description = map.description
                return .init(
                    name: name,
                    wordSize: wordSize,
                    alignmentStyle: alignmentStyle,
                    properties: properties,
                    description: description
                )
            }
        }
        throw EngineError.MissingConfig(key: name, type: StructMap.self, engine: self)
    }
}
