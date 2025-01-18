//
//  File.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

public struct File: PathRepresentable, Hashable, Equatable {
    public let path: String
    
    public init(_ path: String) {
        self.path = path
    }
    
    public var fileType: String {
        return path.fileExtension
    }
    
    public var fileName: String {
        name
    }
}

extension File: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: Self.StringLiteralType) {
        self.init(value)
    }
}


extension File: Comparable {
    public static func < (lhs: File, rhs: File) -> Bool {
        return lhs.path < rhs.path
    }
}

extension File: Codable {
    enum CodingKeys: String, CodingKey {
        case path
    }
}
