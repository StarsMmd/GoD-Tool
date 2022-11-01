//
//  Numbers.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

extension Int {
    
    public var boolean: Bool {
        return self != 0
    }
    
    public var string: String {
        return String(self)
    }
    
    public var unsigned : UInt32 {
        if self >= 0 {
            return UInt32(self)
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
    
    public var byteArray: [Int] {
        var val = self
        var array = [0,0,0,0]
        for j in [3,2,1,0] {
            array[j] = Int(val % 0x100)
            val = val >> 8
        }
        return array
    }
    
    public var byteArrayU16: [Int] {
        var val = self
        var array = [0,0]
        for j in [1,0] {
            array[j] = Int(val % 0x100)
            val = val >> 8
        }
        return array
    }
    
    public var charArray: [UInt8] {
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
}

extension UInt8 {
    func hex() -> String {
        return String(format: "%02x", self.asInt).uppercased()
    }
    
    func hexString() -> String {
        return "0x" + hex()
    }
}
