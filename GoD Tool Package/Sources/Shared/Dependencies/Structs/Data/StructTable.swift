//
//  StructTable.swift
//  
//
//  Created by Stars Momodu on 10/08/2022.
//

import Foundation
import GoDFoundation

public struct StructTableDefinition {

    public let name: String
    public let entryCount: Int
    public let definition: StructDefinition
}

public class StructTableData {

    public let definition: StructDefinition
    public let data: GoDData
    public var count: Int {
        data.length / definition.length
    }

    public init(definition: StructDefinition, data: GoDData) {
        self.definition = definition
        self.data = data
    }

    public subscript(_ index: Int) -> StructData? {
        get {
            get(index: index)
        }
        set {
            set(index: index, to: newValue)
        }
    }

    public func get(index: Int) -> StructData? {
        guard index < count else { return nil }
        let offset = index * definition.length
        return data.read(struct: definition, atAddress: offset)
    }

    @discardableResult
    public func set(index: Int, to value: StructData?) -> Bool {
        guard index < count else { return false }
        let offset = index * definition.length
        return data.write(struct: value, atAddress: offset)
    }
}
