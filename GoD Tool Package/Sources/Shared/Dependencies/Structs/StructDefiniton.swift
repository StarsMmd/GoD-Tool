//
//  CStructDefiniton.swift
//  
//
//  Created by Stars Momodu on 12/06/2022.
//

import Foundation
import GoDFoundation

public enum StructAlignmentStyles: String, Equatable, Codable {
    case none
    case cStyle
}

public struct StructDefinition: Equatable, Codable {

    public struct Property: Equatable, Codable {
        public let name: String
        public let displayName: String
        public let description: String?
        public let type: StructProperty

        public init(name: String, type: StructProperty, description: String? = nil) {
            self.name = name.replacingOccurrences(of: " ", with: "")
            self.displayName = name
            self.description = description
            self.type = type
        }
    }

    public let name: String
    public let wordSize: Int
    public let alignmentStyle: StructAlignmentStyles
    public let properties: [Property]

    public let displayName: String
    public let description: String?

    public var length: Int {
        var sum: Int = 0
        for property in properties {
            switch alignmentStyle {
            case .none: break
            case .cStyle:
                let alignmentOffset = sum % property.type.alignment
                if alignmentOffset > 0 {
                    sum += property.type.alignment - alignmentOffset
                }
            }

            sum += property.type.length
        }
        switch alignmentStyle {
        case .none: break
        case .cStyle:
            let alignmentOffset = sum % longestAlignment
            if alignmentOffset > 0 {
                sum += longestAlignment - alignmentOffset
            }
        }
        return sum
    }

    public var longestAlignment: Int {
        var longest: Int = 0
        for property in properties {
            switch property.type {
            case .primitive(let prim):
                longest = max(longest, prim.length)
            case .array(let property, _):
                longest = max(longest, property.alignment)
            case .subStruct(let substruct):
                longest = max(longest, substruct.longestAlignment)
            case .abstraction(let property, _):
                longest = max(longest, property.alignment)
            }
        }
        return longest
    }

    public init(
        name: String,
        displayName: String? = nil,
        wordSize: Int,
        alignmentStyle: StructAlignmentStyles,
        properties: [Property],
        description: String? = nil
    ) {
        self.name = name.replacingOccurrences(of: " ", with: "")
        self.displayName = displayName ?? name
        self.wordSize = wordSize
        self.alignmentStyle = alignmentStyle
        self.properties = properties
        self.description = description
    }

    public func offset(for keypath: String) -> Int? {
        let keypathParts = keypath.replacingOccurrences(of: " ", with: "").split(separator: ".").map { String($0) }
        let currentKey = keypathParts[0]
        let remainingKeyPath = keypathParts.count == 1 ? nil : keypathParts[1...].joined(separator: ".")

        var offset: Int = 0
        for property in properties {
            switch alignmentStyle {
            case .none: break
            case .cStyle:
                let alignmentOffset = offset % property.type.alignment
                if alignmentOffset > 0 {
                    offset += property.type.alignment - alignmentOffset
                }
            }

            if property.name == currentKey {
                if let keypath = remainingKeyPath {
                    if case .subStruct(let substruct) = property.type {
                        if let subOffset = substruct.offset(for: keypath) {
                            return offset + subOffset
                        }
                        return nil
                    } else {
                        return nil
                    }
                }
                return offset
            }
            offset += property.type.length
        }

        return nil
    }

    public func property(for keypath: String) -> StructProperty? {
        let keypathParts = keypath.replacingOccurrences(of: " ", with: "").split(separator: ".").map { String($0) }
        let currentKey = keypathParts[0]
        let remainingKeyPath = keypathParts.count == 1 ? nil : keypathParts[1...].joined(separator: ".")

        for property in properties {
            if property.name == currentKey {
                if let keypath = remainingKeyPath {
                    if case .subStruct(let substruct) = property.type {
                        return substruct.property(for: keypath)
                    } else {
                        return nil
                    }
                }
                return property.type
            }
        }

        return nil
    }
}

public extension StructDefinition {
    init?(string: String) {
        // regex
        return nil
    }
}

public extension StructDefinition {
    init?(file: File) {
        let text = file.data?.string(format: .utf8)
        guard let string = text else {
            return nil
        }
        self.init(string: string)
    }
}

public extension StructDefinition.Property {

    static func uint8(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.uint8), description: description)
    }

    static func int8(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.int8), description: description)
    }


    static func uint16(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.uint16), description: description)
    }

    static func int16(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.int16), description: description)
    }


    static func uint32(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.uint32), description: description)
    }

    static func int32(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.int32), description: description)
    }


    static func uint64(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.uint64), description: description)
    }

    static func int64(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.int64), description: description)
    }


    static func float(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.float), description: description)
    }

    static func double(name: String, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.double), description: description)
    }


    static func character(name: String, format: StringFormats, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .primitive(.character(format)), description: description)
    }

    static func array(name: String, count: Int, of subProperty: StructProperty, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .array(subProperty, count: count), description: description)
    }

    static func subStruct(name: String, defintion: StructDefinition, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .subStruct(defintion), description: description)
    }

    static func abstraction(name: String, typeName: String, property: StructProperty, description: String? = nil) -> StructDefinition.Property {
        StructDefinition.Property(name: name, type: .abstraction(property, typeName: typeName), description: description)
    }
}
