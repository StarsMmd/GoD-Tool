//
//  Util.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

extension String {
    public var fileExtensions: String {
        let extensionIndex = firstIndex(of: ".") ?? endIndex
        return substring(from: extensionIndex, to: endIndex).substring(from: 1)
    }
    
    public var fileExtension: String {
        let extensionIndex = lastIndex(of: ".") ?? endIndex
        return substring(from: extensionIndex, to: endIndex).substring(from: 1)
    }
    
    public var withoutExtensions: String {
        let extensionIndex = firstIndex(of: ".") ?? endIndex
        return substring(from: startIndex, to: extensionIndex)
    }
    
    public var withoutExtension: String {
        let extensionIndex = lastIndex(of: ".") ?? endIndex
        return substring(from: startIndex, to: extensionIndex)
    }
}
