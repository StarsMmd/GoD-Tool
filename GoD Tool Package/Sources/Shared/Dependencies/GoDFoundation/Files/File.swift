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

    public var fileSize: Int? {
        let fm = FileManager.default
        let attributes = try? fm.attributesOfItem(atPath: path)
        return attributes?[.size] as? Int
    }
    
    public static func resource(_ filename: String, bundle: Bundle) -> File? {
        guard let url = bundle.url(forResource: filename.withoutExtension, withExtension: filename.fileExtension) else {
            return nil
        }
        return File(url.path)
    }
    
    @discardableResult
    public func move(_ newFile: File) -> Bool {
        guard let parentFolder = newFile.parentFolder else {
            return false
        }
        do {
            if !parentFolder.exists {
                parentFolder.create()
            }
            try FileManager.default.moveItem(atPath: self.path, toPath: newFile.path)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func rename(_ newName: String) -> Bool {
        guard let parentFolder = parentFolder else {
            return false
        }
        return move(parentFolder.file(newName))
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
