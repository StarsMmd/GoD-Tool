//
//  CodableExtensions.swift
//  
//
//  Created by Stars Momodu on 13/06/2022.
//

import Foundation

public extension Encodable {
    func encodeJSON() -> GoDData? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return GoDData(data: data)
    }
    
    func encodeJSONString() -> String? {
        return encodeJSON()?.string(format: .utf8)
    }
}

public extension Decodable {
    static func decodeJSON(from data: GoDData) -> Self? {
        return try? JSONDecoder().decode(Self.self, from: data.data)
    }
    
    static func decodeJSON(from string: String) -> Self? {
        return decodeJSON(from: string.data(format: .utf8))
    }
}
