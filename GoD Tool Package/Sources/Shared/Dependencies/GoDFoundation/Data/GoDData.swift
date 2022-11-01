//
//  Data.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

fileprivate extension Data {
    var rawBytes: [UInt8] {
        return self.map { $0 }
    }
}

public final class GoDData: ExpressibleByStringLiteral {

    public private(set) var byteOrder: ByteOrder
    public private(set) var data: Data
    
    public func string(format: StringFormats) -> String {
        let copy = self.copy
        if !format.byteOrder.matches(.big) {
            copy.switchByteOrder(boundary: format.characterLength)
        }
        var string = String(data: copy.data, encoding: format.encoding) ?? ""
        while let last = string.last, last == "\u{00}" {
            string.removeLast()
        }
        return string
    }
    
    public var rawBytes: [UInt8] {
        data.rawBytes
    }
    
    public var byteStream: [Int] {
        rawBytes.map {Int($0)}
    }
    
    public var length: Int {
        data.count
    }

    public init(data: Data = Data(), byteOrder: ByteOrder = .unspecified) {
        self.byteOrder = byteOrder
        self.data = data
    }
    
    public convenience init(data: GoDData) {
        self.init(data: data.copy.data, byteOrder: data.byteOrder)
    }
    
    public convenience init(byteStream: [UInt8], byteOrder: ByteOrder = .unspecified) {
        self.init(data: Data(byteStream), byteOrder: byteOrder)
    }
    
    public convenience init(byteStream: [Int], byteOrder: ByteOrder = .unspecified) {
        self.init(byteStream: byteStream.map{ UInt8($0) }, byteOrder: byteOrder)
    }

    public convenience init(length: Int, byteOrder: ByteOrder = .unspecified) {
        self.init(byteStream: [UInt8](repeating: 0, count: max(0, length)), byteOrder: byteOrder)
    }
    
    public convenience init(string: String, format: StringFormats) {
        if let data = string.data(using: format.encoding) {
            self.init(data: data, byteOrder: Environment.byteOrder)
            if !Environment.byteOrder.matches(format.byteOrder) {
                self.switchByteOrder(boundary: format.characterLength)
            }
        } else {
            self.init()
        }
    }

    public convenience init(character: String, format: StringFormats) {
        if let data = character.data(using: format.encoding) {
            self.init(data: data, byteOrder: Environment.byteOrder)
            if !Environment.byteOrder.matches(format.byteOrder) {
                self.switchByteOrder(boundary: format.characterLength)
            }
            switch format {
            case .unicode_big, .utf16_big,
                 .gs, .gsColo, .gsXD, .gsPBR:
                if self.length >= 2 {
                    if self[0] == 0xFE, self[1] == 0xFF {
                        self.delete(start: 0, count: 2)
                    }
                }
            case .unicode_little, .utf16_little:
                if self.length >= 2 {
                    if self[0] == 0xFF, self[1] == 0xFE {
                        self.delete(start: 0, count: 2)
                    }
                }
            default:
                break
            }
        } else {
            self.init()
        }
    }
    
    public typealias StringLiteralType = String
    public required convenience init(stringLiteral value: StringLiteralType) {
        self.init(string: value, format: .utf8)
    }
    
    public convenience init<T: DataRepresentable>(_ value: T) {
        self.init(data: value.rawData)
    }

    @discardableResult
    public func save(to url: URL) -> Bool {
        do {
            try data.write(to: url, options: [.atomic])
            return true
        } catch {
            return false
        }
    }

    public var copy: GoDData {
        GoDData(byteStream: rawBytes, byteOrder: byteOrder)
    }
    
    public var isNull: Bool {
        rawBytes.firstIndex { $0 != 0 } == nil
    }
    
    public subscript(index: Int) -> UInt8 {
        get {
            return data[index]
        }
        set {
            data[index] = newValue
        }
    }
    
    public subscript(safe index: Int) -> UInt8? {
        guard index < length, index >= 0 else { return nil }
        return data[index]
    }
    
    public func search(for data: GoDData) -> [Int] {
        var offsets = [Int]()
        let searchData = data.data
        var currentStart = 0
        
        while true {
            let resultRange = self.data.range(of: searchData, options: [], in: currentStart ..< length)
            if let resultOffset = resultRange?.startIndex {
                offsets.append(resultOffset)
                currentStart = resultOffset + 1
            } else {
                break
            }
        }
        
        return offsets
    }
    
    public func search(for data: GoDData, fromOffset: Int = 0) -> Int? {
        let searchRange: Range<Data.Index> = fromOffset ..< self.length
        guard let resultRange = self.data.range(of: data.data, options: [], in: searchRange) else {
            return nil
        }
        return Int(resultRange.startIndex)
    }
    
    public func switchByteOrder(boundary: Int) {
        guard byteOrder != .unspecified else {
            return
        }
        byteOrder = byteOrder.swapped
        guard boundary > 1 else { return }
        let loops = ((length - 1) / boundary) + 1
        for i in 0 ..< loops {
            var swappedBytes = [UInt8]()
            for j in 0 ..< boundary {
                if let nextByte = self[safe: (i * boundary) + j] {
                    swappedBytes = [nextByte] + swappedBytes
                }
            }
            self.write(swappedBytes, atAddress: i * boundary)
        }
    }
}

extension GoDData: GoDReadable {
    public func read(atAddress address: UInt, length: UInt) -> GoDData? {
        guard address >= 0, Int(address + length) <= self.length else { return nil }
        return GoDData(data: Data(data.suffix(from: Int(address)).prefix(Int(length))), byteOrder: byteOrder)
    }
}

extension GoDData: GoDWritable {
    @discardableResult
    public func write(_ data: GoDData, atAddress address: UInt) -> Bool {
        let startIndex = Int(address)
        guard startIndex >= 0, startIndex < self.length else {
            return false
        }
        let endIndex = min(startIndex + data.length, self.length)

        guard let subData = data.read(atAddress: 0, length: endIndex - startIndex) else { return false }
        self.data.replaceSubrange(startIndex ..< endIndex, with: subData.data)
        return true
    }
}

extension GoDData: GoDMutableData {
    public func append(_ data: GoDData) {
        self.data.append(data.data)
    }


    public func insert(_ data: GoDData, atOffset offset: UInt) {
        self.data.insert(contentsOf: data.rawBytes, at: Int(offset))
    }

    public func delete(start: Int, count: Int) {
        data.removeSubrange(start ..< start + count)
    }
}

extension GoDData: CustomStringConvertible {
    public var description: String {
        return string(format: .utf8)
    }
}

extension GoDData: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(data)
    }

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        self.init(data: data)
    }
}

extension GoDData: Equatable {
    public static func == (lhs: GoDData, rhs: GoDData) -> Bool {
        lhs.rawBytes == rhs.rawBytes
    }


}












