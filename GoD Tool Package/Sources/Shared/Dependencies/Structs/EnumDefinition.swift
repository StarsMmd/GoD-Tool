//
//  File.swift
//  
//
//  Created by Stars Momodu on 09/08/2022.
//

import Foundation

@dynamicMemberLookup
public struct EnumDefinition {
    public struct EnumCase {
        public let name: String
        public let rawValue: Int
    }

    public let name: String
    public let values: [EnumCase]

    public subscript(dynamicMember caseName: String) -> EnumCase? {
        return values.first { $0.name == caseName }
    }

    public subscript(index: Int) -> EnumCase? {
        return values.first { $0.rawValue == index }
    }
}
