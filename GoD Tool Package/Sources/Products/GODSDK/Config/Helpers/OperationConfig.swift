//
//  File.swift
//  
//
//  Created by Stars Momodu on 09/06/2024.
//

import Foundation

protocol ConfigType {
    associatedtype OperationType
    var operation: OperationType { get }
    var enabled: Bool { get }
}

struct OperationConfig<T: Codable>: Codable, ConfigType {
    typealias OperationType = T
    
    let operation: OperationType
    let enabled: Bool
}

extension Array where Element: ConfigType {
    var enabledEntries: [Element.OperationType] {
        filter(\.enabled).map(\.operation)
    }
}

