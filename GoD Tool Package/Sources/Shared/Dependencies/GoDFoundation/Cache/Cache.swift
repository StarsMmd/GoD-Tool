//
//  Cache.swift
//  
//
//  Created by Stars Momodu on 31/05/2022.
//

import Foundation

open class Cache<Element: AnyObject> {
    
    private let cache: NSCache<NSString, Element> = .init()
    
    public init() {}
    
    public subscript(_ key: String) -> Element? {
        get {
            let nsKey = key as NSString
            return cache.object(forKey: nsKey)
        }
        set {
            let nsKey = key as NSString
            if let object = newValue {
                cache.setObject(object, forKey: nsKey)
            } else {
                cache.removeObject(forKey: nsKey)
            }
        }
    }
    
    public func reset() {
        cache.removeAllObjects()
    }
}
