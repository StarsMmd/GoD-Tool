//
//  Error.swift
//  
//
//  Created by Stars Momodu on 05/06/2024.
//

import Foundation

public enum EngineError: Error, CustomStringConvertible {
    case MissingConfig(key: String, type: Any.Type, engine: Engine)
    
    public var description: String {
        switch self {
        case .MissingConfig(let key, let type, let engine):
            return "Error: Couldn't find config value '\(key)' or type '\(type.self)' in engine '\(engine.name)'"
        }
    }
}
