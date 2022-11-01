//
//  FileCache.swift
//  
//
//  Created by Stars Momodu on 31/05/2022.
//

import Foundation

public class FileCache {
    private let cache = Cache<GoDData>()
    
    public init() {}
    
    public subscript(_ file: File) -> GoDData? {
        get {
            if let data = cache[file.path] {
                return data
            }
            let data = file.data
            cache[file.path] = data
            return data
        }
        set {
            cache[file.path] = newValue
        }
    }
    
    public func reset() {
        cache.reset()
    }
}
