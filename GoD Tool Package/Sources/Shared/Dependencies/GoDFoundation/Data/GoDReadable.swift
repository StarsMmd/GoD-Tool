//
//  GoDReadable.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

public protocol GoDReadable {
    var byteOrder: ByteOrder { get }
    func read(atAddress address: UInt, length: UInt) -> GoDData?
}

extension GoDReadable {
    public func read(atAddress address: Int, length: Int) -> GoDData? {
        return read(atAddress: UInt(address), length: UInt(length))
    }

    public func readValue<T: ExpressibleByFixedLengthData>(atAddress address: Int) -> T? {
        guard let data = read(atAddress: address, length: T.byteLength) else {
            return nil
        }
        return T(data: data)
    }
    
    public func readValues<T: ExpressibleByFixedLengthData>(atAddress address: Int, count: Int) -> [T]? {
        guard let data = read(atAddress: address, length: T.byteLength * count) else {
            return nil
        }
        return Array<T>(data: data)
    }
    
    public func readSafely<T: ExpressibleByFixedLengthData & ValueDefaulting>(atAddress address: Int) -> T {
        guard let data = read(atAddress: address, length: T.byteLength) else {
            return T.defaultValue
        }
        return T(data: data) ?? T.defaultValue
    }
    
    public func readType<T: ExpressibleByFixedLengthData>(_ type: T.Type, atAddress address: Int) -> T? {
        guard let data = read(atAddress: address, length: T.byteLength) else {
            return nil
        }
        return T(data: data)
    }
    
    public func readTypeSafely<T: ExpressibleByFixedLengthData & ValueDefaulting>(_ type: T.Type, atAddress address: Int) -> T {
        guard let data = read(atAddress: address, length: T.byteLength) else {
            return T.defaultValue
        }
        return T(data: data) ?? T.defaultValue
    }
    
    public func readTypeAsInt<T: ExpressibleByFixedLengthData & IntegerConvertible>(_ type: T.Type, atAddress address: Int) -> Int {
        guard let data = read(atAddress: address, length: T.byteLength) else {
            return 0
        }
        return T(data: data)?.asInt ?? 0
    }
    
    public func readPrimtive<T: PrimitiveDataType>(atAddress address: Int) -> T? {
        guard let data = read(atAddress: address, length: T.byteLength) else {
            return nil
        }
        if !data.byteOrder.matches(Environment.byteOrder) {
            data.switchByteOrder(boundary: T.byteLength)
        }
        return T(data: data)
    }
    
    public func readPrimitives<T: PrimitiveDataType>(atAddress address: Int, count: Int) -> [T]? {
        guard let data = read(atAddress: address, length: T.byteLength * count) else {
            return nil
        }
        if !data.byteOrder.matches(Environment.byteOrder) {
            data.switchByteOrder(boundary: T.byteLength)
        }
        return Array<T>(data: data)
    }
    
    internal func readChar(atAddress address: Int, format: StringFormats) -> GSCharacter? {
        let subData = read(atAddress: address, length: format.characterLength)
        if let subData = subData,
           UInt16(data: subData) == 0xFFFF {
            switch format {
            case .gsColo, .gsXD:
                guard let charID: UInt8 = readValue(atAddress: address + 2) else { return nil }
                let paramsLength: Int
                switch charID {
                case 0x07, 0x09, 0x38, 0x52, 0x53, 0x5B, 0x5C: paramsLength = 1
                case 0x8: paramsLength = 4
                default: paramsLength = 0
                }
                guard let paramData = read(atAddress: address + 3, length: paramsLength) else { return nil }
                let paramBytes = paramData.rawBytes
                return GSCharacter.special([charID] + paramBytes)
            case .gsPBR:
                guard let charID: UInt16 = readValue(atAddress: address + 2) else { return nil }
                let paramsLength: Int
                switch charID {
                case 0x01, 0x02, 0x03, 0x04, 0x05: paramsLength = 2
                default: paramsLength = 0
                }
                guard let paramData = read(atAddress: address + 4, length: paramsLength) else { return nil }
                var paramBytes = paramData.rawBytes
                if charID == 1, paramBytes.count == 2 {
                    let kanaCount = Int(paramBytes[0])
                    let kanjiCount = Int(paramBytes[0])
                    let characterLength = (kanaCount + kanjiCount) * 2
                    if let characterData = read(atAddress: address + 6, length: characterLength) {
                        paramBytes += characterData.rawBytes
                    }
                }
                return GSCharacter.special([UInt8(charID >> 8), UInt8(charID & 0xFF)] + paramBytes)
            default:
                return nil
            }
        } else {
            guard let subData = subData else {
                return nil
            }
            if subData.isNull {
                return .raw("\u{00}")
            }
            return GSCharacter.raw(subData.string(format: format))
        }
    }

    public func readString(atAddress address: Int, format: StringFormats, maxCharacters: Int? = nil) -> String? {
        if let maxCharacters = maxCharacters {
            var stringLength = maxCharacters * format.characterLength
            switch format {
            case .gsColo, .gsXD, .gsPBR, .gs, .utf8:
                break
            default:
                stringLength += format.characterLength
            }
            let subData = read(atAddress: address, length: stringLength)
            return subData?.string(format: format)
        } else {
            var nextChar: GSCharacter?
            var result = ""

            var startOffset = 0
            switch format {
            case .unicode_big, .utf16_big:
                if let subData = read(atAddress: address, length: 2) {
                    if subData[0] == 0xFE, subData[1] == 0xFF {
                        startOffset += 2
                    }
                }
            case .unicode_little, .utf16_little:
                if let subData = read(atAddress: address, length: 2) {
                    if subData[0] == 0xFF, subData[1] == 0xFE {
                        startOffset += 2
                    }
                }
            default:
                break
            }
            var offset = startOffset

            repeat {
                nextChar = readChar(atAddress: address + offset, format: format)
                switch (format, nextChar) {
                case (_, .raw("\u{00}")), (.gsPBR, .special([0xFF, 0xFF])):
                    nextChar = nil
                default:
                    result += nextChar?.string(format: format) ?? ""
                }
                switch nextChar {
                case .special:
                    offset += nextChar?.rawData.length ?? 0
                case .raw:
                    offset += format.characterLength
                case nil:
                    break
                }
            } while nextChar != nil

            if offset == startOffset { return nil }
            return result
        }
    }
    
    public func readStringSafely(atAddress address: Int, format: StringFormats, maxCharacters: Int? = nil) -> String {
        return readString(atAddress: address, format: format, maxCharacters: maxCharacters) ?? ""
    }
    
    public func readGSString(atAddress address: Int, format: StringFormats) -> GSString? {
        var nextChar: GSCharacter?
        var result = [GSCharacter]()
        var offset = 0
        repeat {
            switch format {
            case .gsColo: fallthrough
            case .gsXD: fallthrough
            case .gsPBR: fallthrough
            case .gs: nextChar = readChar(atAddress: address + offset, format: format)
            default: nextChar = readChar(atAddress: address + offset, format: .gs)
            }
            
            switch (format, nextChar) {
            case (_, .raw("\u{00}")), (_, .raw("")), (.gsPBR, .special([0xFF, 0xFF])):
                nextChar = nil
            default:
                if let nextChar = nextChar {
                    result.append(nextChar)
                }
                offset += nextChar?.rawData.length ?? 0
            }
        } while nextChar != nil
        guard result.count > 0 else { return nil }
        return GSString(characters: result)
    }
    
    public func readGSStringSafely(atAddress address: Int, format: StringFormats) -> GSString {
        return readGSString(atAddress: address, format: format) ?? ""
    }
}
