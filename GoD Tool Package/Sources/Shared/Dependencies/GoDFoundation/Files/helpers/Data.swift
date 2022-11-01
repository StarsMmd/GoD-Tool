//
//  Data.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

extension GoDData {
    public convenience init?(contentsOfFile file: File) {
        self.init(contentsOfFile: file.path)
    }
    
    public convenience init?(contentsOfFile path: String) {
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else  {
            return nil
        }
        self.init(data: data)
    }
    
    @discardableResult
    public func save(to file: File) -> Bool {
        guard let parentFolder = file.parentFolder else { return false }
        if !parentFolder.exists {
            parentFolder.create()
        }
        return save(to: file.url)
    }
}

fileprivate let fileCache = FileCache()
fileprivate var permanentDataCache = [File: GoDData]()

extension File {
    public var data: GoDData? {
        return GoDData(contentsOfFile: self)
    }
    
    /// Caches the data before returning it.
    /// If previously cached it will be returned directly from the cache
    /// rather than loading the file's data again.
    /// If the system is low on memory the file may be removed from the cache at any time.
    /// Never use this as a source of truth.
    public var cachedData: GoDData? {
        if let data = permanentDataCache[self] {
            return data
        }
        return fileCache[self]
    }
    
    /// Permanently caches the data before returning it.
    /// If previously cached it will be returned directly from the cache
    /// rather than loading the file's data again.
    public var permanentCachedData: GoDData? {
        if let data = permanentDataCache[self] {
            return data
        }
        let data = fileCache[self]
        fileCache[self] = nil
        permanentDataCache[self] = data
        return data
    }
    
    public func removeFromCaches() {
        fileCache[self] = nil
        permanentDataCache[self] = nil
    }
    
    public static func resetCaches() {
        fileCache.reset()
        permanentDataCache.removeAll()
    }
}

extension ExpressibleByData {
    public init?(file: File) {
        guard let data = file.data else {
            return nil
        }
        self.init(data: data)
    }
}
