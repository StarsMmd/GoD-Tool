//
//  JSON.swift
//  
//
//  Created by Stars Momodu on 09/06/2024.
//

import Foundation

public extension JSONDecoder {
    func decode<T>(_ type: T.Type, from data: GoDData) throws -> T where T : Decodable {
        try decode(type, from: data.data)
    }
}

public extension JSONEncoder {
    func encode<Value>(_ value: Value) throws -> GoDData where Value : Encodable {
        let data: Data = try encode(value)
        return GoDData(data: data)
    }
}


public enum JSONDecodingError: Error {
    case invalidToken(String, Any.Type)
    
    var description: String {
        switch self {
        case .invalidToken(let token, let type):
            return "Error: Couldn't decode token '\(token)' as type '\(type.self)'"
        }
    }
}
