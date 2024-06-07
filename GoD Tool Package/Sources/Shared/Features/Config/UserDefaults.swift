//
//  UserDefaults.swift
//  
//
//  Created by Stars Momodu on 12/06/2022.
//

import Foundation
import GoDFoundation

@propertyWrapper
public struct UserDefault<Value> {
    private let key: String
    private let container: UserDefaults = .standard

    public var wrappedValue: Value? {
        get {
            return container.object(forKey: key) as? Value
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
    
    public init(wrappedValue: Value?, _ key: String) {
        self.key = key
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
public struct UserDefaultPath<Value: PathRepresentable> {
    private let key: String
    private let container: UserDefaults = .standard

    public var wrappedValue: Value? {
        get {
            guard let path = container.object(forKey: key) as? String else {
                return nil
            }
            return Value(path)
        }
        set {
            container.set(newValue?.path, forKey: key)
        }
    }
    
    public init(wrappedValue: Value?, _ key: String) {
        self.key = key
        if let path = container.object(forKey: key) as? String {
            self.wrappedValue = Value(path)
        } else {
            self.wrappedValue = wrappedValue
        }
    }
}
