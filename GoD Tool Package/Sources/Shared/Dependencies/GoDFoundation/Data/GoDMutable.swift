//
//  GoDMutable.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

public protocol GoDMutableData: GoDWritable {
    func append(_ data: GoDData)
    func insert(_ data: GoDData, atOffset offset: UInt)
    func delete(start: Int, count: Int)
}

extension GoDMutableData {
    public func append(_ value: DataConvertible) {
        append(value.rawData)
    }

    public func appendString(_ string: String, format: StringFormats, includeTerminator: Bool = false) {
        self.append(string.data(format: format))
        if includeTerminator {
            self.append(GoDData(length: 1))
        }
    }

    public func prepend(_ data: GoDData) {
        insert(data, atOffset: 0)
    }

    public func prepend(_ value: DataConvertible) {
        prepend(value.rawData)
    }

    public func insert(_ data: GoDData, atOffset offset: Int) {
        insert(data, atOffset: UInt(offset))
    }
    
    public func insert(_ value: DataConvertible, atOffset offset: Int) {
        insert(value.rawData, atOffset: offset)
    }
}
