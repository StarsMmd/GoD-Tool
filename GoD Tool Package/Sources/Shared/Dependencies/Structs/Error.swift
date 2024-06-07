//
//  Error.swift
//  
//
//  Created by Stars Momodu on 05/06/2024.
//

import Foundation

public enum StructError: Error, CustomStringConvertible {
    case MissingKey(key: String, struct: StructData)
    case TypeMismatch(key: String, propertyType:StructProperty, type: Any.Type, struct: StructData)
    
    public var description: String {
        switch self {
        case .MissingKey(let key, let structData):
            let keys = structData.properties.map(\.name).joined(separator: "\n")
            return "Error: Couldn't find key '\(key)' in struct '\(structData.name)'\nKeys:\n" + keys
        case .TypeMismatch(let key, let propertyType, let type, let structData):
            return "Error: Couldn't convert key '\(key)' of type '\(propertyType)' to type: `\(type)` in struct '\(structData.name)'"
        }
    }
}
