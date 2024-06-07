//
//  File.swift
//  
//
//  Created by Stars Momodu on 09/08/2022.
//

import Foundation

@dynamicMemberLookup
public struct EnumDefinition: Codable, Equatable {
    public enum Errors: Error, CustomStringConvertible {
        case InvalidEnumIndex(index: Int, enumeration: EnumDefinition)
        case InvalidEnumCase(caseName: String, enumeration: EnumDefinition)
        
        public var description: String {
            switch self {
            case .InvalidEnumIndex(let index, let enumeration):
                return "Invalid index '\(index)' in enum '\(enumeration.name)'"
            case .InvalidEnumCase(let caseName, let enumeration):
                return "Invalid case '\(caseName)' in enum '\(enumeration.name)'"
            }
        }
    }
    
    public struct EnumCase: Codable, Equatable {
        public let name: String
        public let rawValue: Int
    }

    public let name: String
    public let values: [EnumCase]

    public subscript(dynamicMember caseName: String) -> EnumCase {
        get throws {
            try get(caseName)
        }
    }

    public subscript(index: Int) -> EnumCase {
        get throws {
            try get(index)
        }
    }
    
    public func get(_ caseName: String) throws -> EnumCase {
        guard let value = values.first(where: { $0.name == caseName }) else {
            throw Errors.InvalidEnumCase(caseName: caseName, enumeration: self)
        }
        return value
    }

    public func get(_ index: Int) throws -> EnumCase {
        guard let value = values.first(where: { $0.rawValue == index }) else {
            throw Errors.InvalidEnumIndex(index: index, enumeration: self)
        }
        return value
    }
}
