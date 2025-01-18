//
//  DataRepresentable.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

public protocol DataConvertible {
    var rawData: GoDData { get }
}

public protocol ExpressibleByData {
    init?(data: GoDData)
}

public protocol FixedByteLength {
    static var byteLength: Int { get }
}

public protocol ValueDefaulting {
    static var defaultValue: Self { get }
}

public typealias DataRepresentable = DataConvertible & ExpressibleByData
public typealias ExpressibleByFixedLengthData = ExpressibleByData & FixedByteLength
public typealias FixedLengthDataRepresentable = DataRepresentable & FixedByteLength

public protocol PrimitiveDataType: FixedLengthDataRepresentable {}

public extension PrimitiveDataType {
    var rawData: GoDData {
        let bytesPointer = UnsafeMutableRawPointer.allocate(byteCount: Self.byteLength, alignment: Environment.wordSize)
        bytesPointer.storeBytes(of: self, as: Self.self)
        let data = Data(bytes: bytesPointer, count: Self.byteLength)
        bytesPointer.deallocate()
        return GoDData(data: data, byteOrder: Environment.byteOrder)
    }
}
   
public extension PrimitiveDataType {
    init?(data: GoDData) {
        let copy = data.copy
        if !copy.byteOrder.matches(Environment.byteOrder) {
            copy.switchByteOrder(boundary: Environment.wordSize)
        }
        if data.length < Self.byteLength {
            let extra = Self.byteLength - data.length
            let extraWords = extra / Environment.wordSize
            let extraBytes = extra % Environment.wordSize
            
            let extraBytesData = GoDData(length: extraBytes)
            if Environment.byteOrder == .little {
                copy.append(extraBytesData)
            } else {
                copy.insert(extraBytesData, atOffset: 0)
            }
            
            let extraWordsData = GoDData(length: extraWords * Environment.wordSize)
            copy.insert(extraWordsData, atOffset: 0)
            
        }
        let bytesPointer = UnsafeMutableRawBufferPointer.allocate(byteCount: copy.length, alignment: Environment.wordSize)
        copy.data.copyBytes(to: bytesPointer)
        let value = bytesPointer.load(as: Self.self)
        bytesPointer.deallocate()
        self = value
    }
}

public extension ExpressibleByData where Self: ValueDefaulting {
    static func initSafely(from data: GoDData) -> Self {
        return Self(data: data) ?? defaultValue
    }
}

extension Bool: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { 1 }
    public static var defaultValue: Bool { false }
    
    public var rawData: GoDData {
        GoDData(byteStream: self ? [1] : [0])
    }
    
    public init?(data: GoDData) {
        self = !data.isNull
    }
}

extension UInt: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { bitWidth / 8 }
    public static var defaultValue: UInt { 0 }
}

extension Int: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { bitWidth / 8 }
    public static var defaultValue: Int { 0 }
}

extension Int64: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { bitWidth / 8 }
    public static var defaultValue: Int64 { 0 }
}

extension UInt64: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { bitWidth / 8 }
    public static var defaultValue: UInt64 { 0 }
}

extension Int32: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { 4 }
    public static var defaultValue: Int32 { 0 }
}

extension UInt32: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { 4 }
    public static var defaultValue: UInt32 { 0 }
}

extension Int16: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { 2 }
    public static var defaultValue: Int16 { 0 }
}

extension UInt16: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { 2 }
    public static var defaultValue: UInt16 { 0 }
}

extension Int8: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { 1 }
    public static var defaultValue: Int8 { 0 }
}

extension UInt8: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { 1 }
    public static var defaultValue: UInt8 { 0 }
}

extension Float: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { 4 }
    public static var defaultValue: Float { 0 }
}

extension Double: PrimitiveDataType, ValueDefaulting {
    public static var byteLength: Int { 8 }
    public static var defaultValue: Double { 0 }
}

extension Array: ValueDefaulting {
    public static var defaultValue: Array<Element> { [] }
}

extension Array: DataConvertible where Element: DataConvertible & FixedByteLength {
    public var rawData: GoDData {
        let order: ByteOrder = Element.byteLength < Environment.wordSize ? .unspecified : Environment.byteOrder
        let data = GoDData(byteOrder: order)
        for value in self {
            data.append(value)
        }
        return data
    }
}

extension Array: ExpressibleByData where Element: ExpressibleByFixedLengthData {
    public init?(data: GoDData) {
        var array = [Element]()
        var offset = 0
        while offset + Int(Element.byteLength) <= data.length {
            if let value: Element = data.readValue(atAddress: offset) {
                array.append(value)
            }
            offset += Int(Element.byteLength)
        }
        self = array
    }
}

extension GoDData {
    public func search(for data: DataConvertible) -> [Int] {
        search(for: data.rawData)
    }
}
