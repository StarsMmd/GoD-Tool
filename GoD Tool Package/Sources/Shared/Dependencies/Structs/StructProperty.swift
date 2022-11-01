//
//  CProperty.swift
//  
//
//  Created by Stars Momodu on 12/06/2022.
//

import Foundation
import GoDFoundation

public enum StructPrimitives: Equatable, Codable {
    case uint8, int8
    case uint16, int16
    case uint32, int32
    case uint64, int64
    case float, double
    case character(StringFormats)

    public var length: Int {
        switch self {
        case .uint8, .int8:
            return 1
        case .uint16, .int16:
            return 2
        case .uint32, .int32:
            return 4
        case .uint64, .int64:
            return 8
        case .float:
            return 4
        case .double:
            return 8
        case .character(let format):
            switch format {
            case .utf8:
                return 1
            case .utf16_big, .utf16_little, .ascii_big, .ascii_little, .unicode_big, .unicode_little,
                 .gsColo, .gsXD, .gsPBR, .gs:
                return 2
            }
        }
    }
}

public indirect enum StructProperty: Equatable, Codable {
    case primitive(StructPrimitives)
    case array(StructProperty, count: Int)
    case subStruct(StructDefinition)
    case abstraction(StructProperty, typeName: String)

    public static func string(format: StringFormats, length: Int) -> StructProperty {
        return .array(.primitive(.character(format)), count: length)
    }

    public var length: Int {
        switch self {
        case .primitive(let type):
            return type.length
        case .array(let type, let count):
            return type.length * count
        case .subStruct(let definition):
            return definition.length
        case .abstraction(let type, _):
            return type.length
        }
    }

    var alignment: Int {
        switch self {
        case .primitive(let prim):
            return prim.length
        case .array(let property, let count):
            return count > 0 ? property.alignment : 0
        case .subStruct(let definition):
            return definition.longestAlignment
        case .abstraction(let property, _):
            return property.alignment
        }
    }
}

