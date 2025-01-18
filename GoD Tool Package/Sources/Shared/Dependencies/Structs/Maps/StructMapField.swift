//
//  StructMapField.swift
//  
//
//  Created by Stars Momodu on 21/06/2024.
//

import GoDFoundation

public indirect enum StructField: Equatable {
    case primitive(StructPrimitives)
    case array(StructField, count: Int)
    case subStruct(name: String)
    case enumeration(name: String)
    case padding(length: Int)

    public static func string(format: StringFormats, length: Int) -> StructField {
        return .array(.primitive(.character(format)), count: length)
    }
}

public extension StructField {
    static var void: StructField { .primitive(.void)}
    static var boolean: StructField { .primitive(.boolean)}
    static var uint8: StructField { .primitive(.integer(.uint8))}
    static var int8: StructField { .primitive(.integer(.int8))}
    static var uint16: StructField { .primitive(.integer(.uint16))}
    static var int24: StructField { .primitive(.integer(.int24))}
    static var uint24: StructField { .primitive(.integer(.uint24))}
    static var int16: StructField { .primitive(.integer(.int16))}
    static var uint32: StructField { .primitive(.integer(.uint32))}
    static var int32: StructField { .primitive(.integer(.int32))}
    static var uint64: StructField { .primitive(.integer(.uint64))}
    static var int64: StructField { .primitive(.integer(.int64))}
    static var float: StructField { .primitive(.float)}
    static var double: StructField { .primitive(.double)}
}

extension StructField: CustomStringConvertible {
    public var description: String {
        func typeString(_ type: StructField) -> String {
            switch type {
            case .primitive(let type):
                return type.description
            case .array(let field, count: let count):
                return "\(field.description)[\(count)]"
            case .subStruct(let name):
                return "struct \(name)"
            case .enumeration(let name):
                return "enum \(name)"
            case .padding(length: let length):
                return "void[\(length)]"
            }
        }
        return typeString(self)
    }
}
