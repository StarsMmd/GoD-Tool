//
//  Numbers.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

public extension Int {
    
    var boolean: Bool {
        return self != 0
    }
    
    var string: String {
        return String(self)
    }
    
    var unsigned : UInt32 {
        if self >= 0 {
            return UInt32(self & 0xFFFFFFFF)
        }
        return UInt32(0xFFFFFFFF) - UInt32(-(self + 1))
    }
    
    func hex() -> String {
        return String(format: "%x", self).uppercased()
    }
    
    func hexString() -> String {
        return "0x" + hex()
    }
    
    func binary() -> String {
        var s = String(self, radix: 2)
        while s.count % 8 != 0 {
            s = "0" + s
        }
        return s
    }
    
    func binaryString() -> String {
        return "0b" + binary()
    }
    
    var byteArray: [Int] {
        var val = self
        var array = [0,0,0,0]
        for j in [3,2,1,0] {
            array[j] = Int(val % 0x100)
            val = val >> 8
        }
        return array
    }
    
    var byteArrayU16: [Int] {
        var val = self
        var array = [0,0]
        for j in [1,0] {
            array[j] = Int(val % 0x100)
            val = val >> 8
        }
        return array
    }
    
    var charArray: [UInt8] {
        return byteArray.map({ (i) -> UInt8 in
            return UInt8(i)
        })
    }

    func bits(count: Int, startWithLeastSignificantBit: Bool = true) -> [Int] {
        var value = self
        var bits = [Int]()
        for _ in 0 ..< count {
            bits.append(value & 0x1)
            value = value >> 1
        }

        if startWithLeastSignificantBit {
            return bits
        } else {
            return bits.reversed()
        }
    }
    
    func bitArray(count: Int, startWithLeastSignificantBit: Bool = true) -> [Bool] {
        bits(count: count, startWithLeastSignificantBit: startWithLeastSignificantBit).map { (bit) -> Bool in
            return bit == 1
        }
    }
    
    var int8Value: Int {
        return self & 0xFF
    }
    
    var int16Value: Int {
        return self & 0xFFFF
    }
    
    var int32Value: Int {
        // Implementation which works on 32 bit platforms which can't have an Int literal of 0xFFFFFFFF
        let excessBytes = Environment.wordSize - 4
        let excessBits = excessBytes * 8
        var value = self
        if excessBits > 0 {
            value = value << excessBits
            value = value >> excessBits
        }
        return value
    }
}

public extension UInt8 {
    
    func hex() -> String {
        return String(format: "%02x", self.asInt).uppercased()
    }
    
    func hexString() -> String {
        return "0x" + hex()
    }
    
    func normalized() -> Double {
        Double(self) / 255
    }
}
