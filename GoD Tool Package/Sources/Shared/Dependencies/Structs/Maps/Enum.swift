//
//  EnumDefinition.swift
//  
//
//  Created by Stars Momodu on 09/08/2022.
//

import GoDFoundation

@dynamicMemberLookup
public struct Enum: Codable, Equatable {
    public enum Errors: Error, CustomStringConvertible {
        case InvalidEnumIndex(index: Int, enumeration: Enum)
        case InvalidEnumCase(caseName: String, enumeration: Enum)
        
        public var description: String {
            switch self {
            case .InvalidEnumIndex(let index, let enumeration):
                return "Invalid index '\(index)' in enum '\(enumeration.name)'"
            case .InvalidEnumCase(let caseName, let enumeration):
                return "Invalid case '\(caseName)' in enum '\(enumeration.name)'"
            }
        }
    }
    
    public struct Case: Codable, Equatable {
        public let name: String
        public let rawValue: Int
    }

    public let name: String
    public let allowUnknownCases: Bool
    public let values: [Case]
    public let propertyType: IntegerProperties

    public subscript(dynamicMember caseName: String) -> Case {
        get throws {
            try get(caseName)
        }
    }

    public subscript(index: Int) -> Case {
        get throws {
            try get(index)
        }
    }
    
    public func get(_ caseName: String) throws -> Case {
        guard let value = values.first(where: { $0.name.lowercased() == caseName.lowercased() }) else {
            throw Errors.InvalidEnumCase(caseName: caseName, enumeration: self)
        }
        return value
    }

    public func get(_ index: Int) throws -> Case {
        guard let value = values.first(where: { $0.rawValue == index }) else {
            guard allowUnknownCases else {
                throw Errors.InvalidEnumIndex(index: index, enumeration: self)
            }
            return unknown(index)
        }
        return value
    }
    
    private func unknown(_ index: Int) -> Case {
        .init(name: "\(name.replacingOccurrences(of: " ", with: "_"))_\(index)", rawValue: index)
    }
}
