//
//  ByteOrder.swift
//  
//
//  Created by Stars Momodu on 12/06/2022.
//

import Foundation

public enum ByteOrder: String, Equatable, Codable {
    case unspecified
    case big
    case little

    public var swapped: ByteOrder {
        switch self {
        case .big: return .little
        case .little: return .big
        case .unspecified: return .unspecified
        }
    }

    public func matches(_ other: ByteOrder) -> Bool {
        switch (self, other) {
        case (.big, .big), (.big, .unspecified), (.unspecified, .big),
             (.little, .little), (.little, .unspecified), (.unspecified, .little),
            (.unspecified, .unspecified):
            return true
        default:
            return false
        }
    }
}
