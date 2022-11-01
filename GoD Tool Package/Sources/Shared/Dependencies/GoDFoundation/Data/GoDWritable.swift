//
//  GoDWritable.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

public protocol GoDWritable {
    var byteOrder: ByteOrder { get }
    @discardableResult
    func write(_ data: GoDData, atAddress address: UInt) -> Bool
}

extension GoDWritable {
    @discardableResult
    public func write(_ data: GoDData?, atAddress address: UInt) -> Bool {
        guard let data = data else {
            return true
        }
        return write(data, atAddress: address)
    }

    @discardableResult
    public func write(_ data: GoDData?, atAddress address: Int) -> Bool {
        return write(data, atAddress: UInt(address))
    }

    @discardableResult
    public func write(_ value: DataConvertible?, atAddress address: Int) -> Bool {
        return write(value?.rawData, atAddress: address)
    }
    
    @discardableResult
    public func write<T: DataConvertible & ExpressibleByInteger>(_ value: Int?, AsType: T.Type, atAddress address: Int) -> Bool {
        guard let value = value else {
            return true
        }
        return write(T(integer: value), atAddress: address)
    }
    
    @discardableResult
    func writeCharacter(_ character: String?, atAddress offset: Int, format: StringFormats) -> Bool {
        write(character?.data(format: format), atAddress: offset)
    }
    
    @discardableResult
    func write(_ string: String?, atAddress offset: Int, format: StringFormats, maxCharacters: Int? = nil, includeNullTerminator: Bool = true) -> Bool {
        guard let string = string else {
            return true
        }

        let outputString: String
        if let maxCharacters = maxCharacters {
            if string.count < maxCharacters {
                outputString = string + String(repeating: "\u{00}", count: maxCharacters - string.count)
            } else {
                outputString = string.substring(from: 0, to: maxCharacters)
            }
        } else {
            outputString = string + (includeNullTerminator ? "\u{00}" : "")
        }
        var charOffset = 0
        for character in outputString {
            guard writeCharacter(String(character), atAddress: offset + charOffset, format: format) else {
                return false
            }
            charOffset += format.characterLength
        }
        return true
    }
    
    @discardableResult
    func write(_ string: GSString?, atAddress offset: Int, format: StringFormats, includeNullTerminator: Bool = true) -> Bool {
        guard let string = string else {
            return true
        }
        let terminator: [UInt8]
        switch format {
        case .gsPBR: terminator = [0xFF, 0xFF, 0xFF, 0xFF]
        default: terminator = [0x00, 0x00]
        }
        return write(string.rawData.rawBytes + (includeNullTerminator ? terminator : []), atAddress: offset)
    }

    public func null(start: Int, length: Int) {
        write(GoDData(length: length), atAddress: start)
    }
}
