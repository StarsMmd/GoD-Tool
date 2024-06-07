//
//  IntegerConvertible.swift
//  
//
//  Created by Stars Momodu on 29/05/2022.
//

import Foundation

public protocol IntegerConvertible {
    var asInt: Int { get }
}

public protocol ExpressibleByInteger {
    init(integer: Int)
}

public typealias IntegerRepresentable = IntegerConvertible & ExpressibleByInteger

extension Int32: IntegerRepresentable {
    public var asInt: Int { Int(self) }
    public init(integer: Int) {
        self =  Int32(integer.int32Value)
    }
}

extension UInt32: IntegerRepresentable {
    public var asInt: Int { Int(self) }
    public init(integer: Int) {
        self = UInt32(bitPattern: Int32(integer.int32Value))
    }
}

extension Int16: IntegerRepresentable {
    public var asInt: Int { Int(self) }
    public init(integer: Int) {
        self = Int16(bitPattern: UInt16(integer.int16Value))
    }
}

extension UInt16: IntegerRepresentable {
    public var asInt: Int { Int(self) }
    public init(integer: Int) {
        self = UInt16(integer.int16Value)
    }
}

extension Int8: IntegerRepresentable {
    public var asInt: Int { Int(self) }
    public init(integer: Int) {
        self = Int8(bitPattern: UInt8(integer.int8Value))
    }
}

extension UInt8: IntegerRepresentable {
    public var asInt: Int { Int(self) }
    public init(integer: Int) {
        self = UInt8(integer.int8Value)
    }
}

extension Array: IntegerRepresentable where Element: IntegerRepresentable & FixedByteLength {
    public var asInt: Int {
        guard Element.byteLength > 0 else { return 0 }
        var value = 0
        let integerByteLength = 4
        let elementByteLength = Int(Element.byteLength)
        let maxElements = integerByteLength / elementByteLength
        
        for i in (0 ..< Swift.min(maxElements, self.count)) {
            value = value << (elementByteLength * 8)
            let nextElement = self[i]
            value += nextElement.asInt
        }
        return value
    }
    
    public init(integer: Int) {
        guard Element.byteLength > 0 else {
            self = []
            return
        }
        var value = [Element]()
        let integerByteLength = 4
        let elementByteLength = Int(Element.byteLength)
        let maxElements = integerByteLength / elementByteLength
        let mask = (1 << (elementByteLength * 8)) - 1
        
        for i in 0 ..< maxElements {
            let nextValue = (integer >> (i * elementByteLength * 8)) & mask
            let nextElement = Element(integer: nextValue)
            value.append(nextElement)
        }
        self = value.reversed()
    }
}

public extension IntegerConvertible {
    func hex() -> String {
        return String(format: "%x", self.asInt).uppercased()
    }
    
    func hexString() -> String {
        return "0x" + hex()
    }
}
