//
//  EngineEntry.swift
//  
//
//  Created by Stars Momodu on 07/06/2024.
//

import Foundation

public class EngineEntry<T: Codable>: Codable {
    public typealias EntryType = T
    
    public let name: String
    public let values: [String: EntryType]
    
    public init(name: String, values: [String: EntryType]) {
        self.name = name
        self.values = values
    }
    
    public func match(_ matchKey: String) -> EntryType? {
        for (key, value) in values {
            if key.matches(matchKey) {
                return value
            }
        }
        return nil
    }
}
