//
//  PathRepresentable.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

public protocol PathRepresentable: CustomStringConvertible {
    var path: String { get }
    var description: String { get }
    init(_ path: String)
}

public extension PathRepresentable {
    var url: URL {
        return URL(fileURLWithPath: path)
    }
    
    var description: String {
        return path
    }
    
    var name: String {
        let nameIndex = path.lastIndex(of: "/") ?? path.endIndex
        return path.substring(from: nameIndex, to: path.endIndex).substring(from: 1)
    }
    
    /// The folder containing this item
    var parentFolder: Folder? {
        if path == "/" {
            return nil
        }
        guard let lastPathComponentIndex = path.lastIndex(of: "/") else {
            return nil
        }
        if path.substring(from: 0, to: 1) == "/",
           !path.substring(from: 1).contains("/") {
            return "/"
        }
        return Folder(path.substring(from: path.startIndex, to: lastPathComponentIndex))
    }
}

public extension Array where Element: PathRepresentable {
    func contains(_ item: PathRepresentable) -> Bool {
        return contains { $0.path == item.path }
    }
}

public extension Array where Element == PathRepresentable {
    func contains(_ item: PathRepresentable) -> Bool {
        return contains { $0.path == item.path }
    }
}
