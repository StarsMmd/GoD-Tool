//
//  StructMap.swift
//  
//
//  Created by Stars Momodu on 21/06/2024.
//

import GoDFoundation

public final class StructMap {
    
    public struct Property: Equatable {
        public let name: String
        public let description: String?
        public let type: StructField

        public init(name: String, type: StructField, description: String? = nil) {
            self.name = name
            self.description = description
            self.type = type
        }
    }

    public let name: String
    public let wordSize: Int
    public let alignmentStyle: StructAlignmentStyles
    public let properties: [Property]
    public let description: String?

    public init(
        name: String,
        wordSize: Int,
        alignmentStyle: StructAlignmentStyles,
        properties: [Property],
        description: String? = nil
    ) {
        self.name = name
        self.wordSize = wordSize
        self.alignmentStyle = alignmentStyle
        self.properties = properties
        self.description = description
    }
}

extension StructMap: Encodable {
    public enum CodingKeys: String, CodingKey {
        case name, description, properties, alignmentStyle, wordSize
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(wordSize, forKey: .wordSize)
        try container.encode(alignmentStyle, forKey: .alignmentStyle)
        
        let propertyList = properties.map { property in
            return "\(property.type) \(property.name.snakeCased)"
        }
        try container.encode(propertyList, forKey: .properties)
    }
}

extension StructMap: Decodable {
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String?.self, forKey: .description)
        let wordSize = try container.decode(Int.self, forKey: .wordSize)
        let alignmentStyle = try container.decode(StructAlignmentStyles.self, forKey: .alignmentStyle)
        let propertyList = try container.decode([String].self, forKey: .properties)
        
        let properties: [StructMap.Property] = try propertyList.map { text in
            func getType(_ token: String) throws -> StructField {
                if let primitive = StructPrimitives.from(name: token) {
                    return .primitive(primitive)
                } else if token.startsWith("void["),
                       let count = token.substring(from: 5, to: -1).integerValue {
                    return .padding(length: count)
                } else if token.last == "]",
                      let lastOpenIndex = token.lastIndex(of: "["),
                      let lastCloseIndex = token.lastIndex(of: "]") {
                    
                    let countString = token.substring(from: lastOpenIndex, to: lastCloseIndex).substring(from: 1)
                    if let count = countString.integerValue {
                        let prefix = String(token.prefix(upTo: lastOpenIndex))
                        return .array(try getType(prefix), count: count)
                    }
                } else if token.startsWith("enum ") {
                    let suffix = token.substring(from: 5)
                    return .enumeration(name: suffix)
                } else if token.startsWith("struct ") {
                    let suffix = token.substring(from: 7)
                    return .subStruct(name: suffix)
                }
                throw JSONDecodingError.invalidToken(token, StructField.self)
            }
            guard let lastSpace = text.lastIndex(of: " ") else {
                throw JSONDecodingError.invalidToken(text, StructMap.Property.self)
            }
            let typeToken = String(text.prefix(upTo: lastSpace))
            let nameToken =  String(text.suffix(from: lastSpace)).substring(from: 1)
            let type = try getType(typeToken)
            return .init(name: nameToken.unsnakeCased, type: type)
        }
        self.init(
            name: name,
            wordSize: wordSize,
            alignmentStyle: alignmentStyle,
            properties: properties,
            description: description
        )
    }
}

public extension StructMap.Property {

    static func uint8(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .uint8, description: description)
    }

    static func int8(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .int8, description: description)
    }


    static func uint16(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .uint16, description: description)
    }

    static func int16(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .int16, description: description)
    }
    
    
    static func uint24(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .uint24, description: description)
    }

    static func int24(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .int24, description: description)
    }


    static func uint32(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .uint32, description: description)
    }

    static func int32(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .int32, description: description)
    }


    static func uint64(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .uint64, description: description)
    }

    static func int64(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .int64, description: description)
    }


    static func float(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .float, description: description)
    }

    static func double(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .double, description: description)
    }
    
    
    static func boolean(name: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .boolean, description: description)
    }


    static func character(name: String, format: StringFormats, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .primitive(.character(format)), description: description)
    }
    
    static func string(name: String, format: StringFormats, length: Int, description: String? = nil) -> StructMap.Property {
        array(name: name, count: length, of: .primitive(.character(format)))
    }

    static func array(name: String, count: Int, of subProperty: StructField, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .array(subProperty, count: count), description: description)
    }

    static func subStruct(name: String, typeName: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .subStruct(name: typeName), description: description)
    }

    static func abstraction(name: String, typeName: String, description: String? = nil) -> StructMap.Property {
        StructMap.Property(name: name, type: .enumeration(name: typeName), description: description)
    }
    
    static func padding(length: Int) -> StructMap.Property {
        StructMap.Property(name: "padding", type: .array(.uint8, count: length))
    }
}
