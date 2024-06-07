//
//  CStructParser.swift
//  
//
//  Created by Stars Momodu on 11/06/2022.
//

import Foundation
import GoDFoundation

@dynamicMemberLookup
public class StructData: Codable {

    public let definition: StructDefinition
    public let data: GoDData

    public var name: String { definition.name }
    public var properties: [StructDefinition.Property] { definition.properties }
    public var byteOrder: ByteOrder { data.byteOrder }
    public var length: Int { definition.length }
    public var wordSize: Int { definition.wordSize }

    public init(
        definition: StructDefinition,
        data: GoDData
    ) {
        self.definition = definition
        self.data = data

        if data.length < definition.length {
            let difference = Int(definition.length) - data.length
            data.append(GoDData(length: difference))
        }
    }
    
    public convenience init(definition: StructDefinition, byteOrder: ByteOrder) {
        self.init(definition: definition, data: GoDData(length: definition.length, byteOrder: byteOrder))
    }
    
    public subscript(dynamicMember member: String) -> GoDData {
        get throws {
            guard let data: GoDData = self.get(member) else {
                throw StructError.MissingKey(key: member, struct: self)
            }
            return data
        }
    }

    public subscript(dynamicMember member: String) -> GoDData? {
        get {
            self.get(member)
        }
        set {
            self.set(member, to: newValue)
        }
    }
    
    public subscript(dynamicMember member: String) -> StructData {
        get throws {
            guard let data: StructData = self.get(member) else {
                throw StructError.MissingKey(key: member, struct: self)
            }
            return data
        }
    }

    public subscript(dynamicMember member: String) -> StructData? {
        get {
            self.get(member)
        }
        set {
            self.set(member, to: newValue?.data)
        }
    }
    
    public subscript<T: ExpressibleByData>(dynamicMember member: String) -> T {
        get throws {
            let data: GoDData = try self[dynamicMember: member]
            guard let value = T(data: data) else {
                let type = definition.property(for: member) ?? .void
                throw StructError.TypeMismatch(key: member, propertyType: type, type: T.self, struct: self)
            }
            return value
        }
    }

    public subscript<T: DataRepresentable>(dynamicMember member: String) -> T? {
        get {
            self.get(member)
        }
        set {
            self.set(member, to: newValue?.rawData)
        }
    }
    
    public subscript(dynamicMember member: String) -> Int? {
        get {
            self.get(member)
        }
        set {
            self.set(member, to: newValue)
        }
    }
    
    public subscript(dynamicMember member: String) -> String {
        get throws {
            let data: GoDData = try self[dynamicMember: member]
            return data.string(format: .utf8)
        }
    }

    public func get(_ keypath: String) -> GoDData? {
        guard let offset = definition.offset(for: keypath),
              let length = definition.property(for: keypath)?.length else {
            return nil
        }

        return data.read(atAddress: offset, length: length)
    }

    public func get(_ keypath: String) -> StructData? {
        guard let property = definition.property(for: keypath),
              let data: GoDData = get(keypath),
              case let .subStruct(structDefinition) = property else {
            return nil
        }

        return StructData(definition: structDefinition, data: data)
    }

    public func get<T: ExpressibleByData>(_ keypath: String) -> T? {
        guard let data: GoDData = get(keypath) else {
            return nil
        }
        return T(data: data)
    }
    
    public func getString(_ keypath: String, format: StringFormats) -> String? {
        guard let data: GoDData = get(keypath) else {
            return nil
        }
        return data.string(format: format)
    }
    
    public func set(_ keypath: String, to value: Int?) {
        let data = (value ?? 0).rawData
        if byteOrder != .unspecified, byteOrder != Environment.byteOrder {
            data.switchByteOrder(boundary: Environment.wordSize)
        }
        set(keypath, to: data)
    }

    public func set(_ keypath: String, to value: GoDData?) {
        guard let offset = definition.offset(for: keypath),
              let length = definition.property(for: keypath)?.length else {
            return
        }
        let newValue = value?.copy ?? GoDData(length: length)
        
        if !newValue.byteOrder.matches(self.byteOrder) {
            newValue.switchByteOrder(boundary: wordSize)
        }
        if newValue.length > length {
            let extra = newValue.length - length
            let extraWords = extra / wordSize
            let extraBytes = extra % wordSize
            for _ in 0 ..< extraWords {
                newValue.delete(start: 0, count: wordSize)
            }
            if byteOrder == .little {
                newValue.delete(start: wordSize - extraBytes, count: extraBytes)
            } else {
                newValue.delete(start: 0, count: extraBytes)
            }
        }
        if newValue.length < length {
            newValue.prepend(GoDData(length: length - newValue.length))
        }
        data.write(newValue, atAddress: offset)
    }

    public func set<T: DataConvertible>(_ keypath: String, to value: T) {
        set(keypath, to: value.rawData)
    }
    
    public func set(_ keypath: String, to value: String, format: StringFormats) {
        set(keypath, to: value.data(format: format))
    }
}

extension StructData: Equatable {

    public static func == (lhs: StructData, rhs: StructData) -> Bool {
        lhs.data.rawBytes == rhs.data.rawBytes
    }
}

extension StructData: CustomStringConvertible {
    public var description: String {
        func description(for primitive: StructPrimitives, name: String) -> String {
            switch primitive {
            case .void:
                return "\(name) = null"
            case .integer:
                guard let value: Int = get(name) else { return "\(name) = N/A" }
                return "\(name) = \(value)"
            case .float:
                guard let value: Float = get(name) else { return "\(name) = N/A" }
                return "\(name) = \(value)"
            case .double:
                guard let value: Double = get(name) else { return "\(name) = N/A" }
                return "\(name) = \(value)"
            case .boolean:
                guard let value: Bool = get(name) else { return "\(name) = N/A" }
                return "\(name) = \(value)"
            case .character(let format):
                guard let string: String = getString(name, format: format) else { return "\(name) = N/A" }
                return "\(name) = \(string)"
            }
        }
        
        var result = ""
        for property in properties {
            let name = property.name
            let typeName = property.type.description
            
            switch property.type {
            case .primitive(let type):
                result += description(for: type, name: name) + " <\(typeName)>\n"
            case .array(.primitive(.character(let format)), _):
                result += description(for: .character(format), name: name) + " <\(typeName)>\n"
            case .abstraction(let enumeration, _):
                guard let value: Int = get(name) else { result += "\(name) = N/A"; continue }
                result += "\(name) = \(value)"
                if let enumValue = try? enumeration.get(value) {
                    result += " \(enumValue.name)"
                }
            case .subStruct:
                guard let data: StructData = get(name) else {
                    result += "N/A"; continue
                }
                result += "\(name):\n" + data.description + "\n"
            case .array(_, let count):
                result += "\(name): \(count) items <\(typeName)>\n"
            case .padding:
                continue
            }
        }
        result.removeLast()
        return result
    }
}
