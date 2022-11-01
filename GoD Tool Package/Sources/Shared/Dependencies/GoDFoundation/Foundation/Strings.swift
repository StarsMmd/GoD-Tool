//
//  Strings.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation
import AppKit

public extension CustomStringConvertible {
    func println() {
        print(self)
    }
}

public extension String {
    
    /// includes from, excludes to
    func substring(from: String.Index, to: String.Index) -> String {
        return String(self[from..<to])
    }
    
    /// includes from, excludes to
    func substring(from: Int, to: Int? = nil) -> String {
        
        let start = from < 0 ? count + from : from
        let end = (to ?? count) < 0 ? count + (to ?? count) : (to ?? count)
        
        if end <= start {
            return ""
        }
        if start > self.count {
            return ""
        }
        if end <= 0 {
            return ""
        }
        
        let f = start < 0 ? 0 : start
        let t = end > self.count ? self.count : end
        
        let startIndex = self.index(self.startIndex, offsetBy: f)
        let endIndex = self.index(self.startIndex, offsetBy: t)
        return String(self[startIndex..<endIndex])
    }
    
    func data(format: StringFormats) -> GoDData {
        return GoDData(string: self, format: format)
    }
    
    func startsWith(_ substring: String) -> Bool {
        guard substring.count <= self.count else { return false }
        return self.substring(from: 0, to: substring.count) == substring
    }
    
    func endsWith(_ substring: String) -> Bool {
        guard substring.count <= self.count else { return false }
        return self.substring(from: self.count - substring.count, to: self.count) == substring
    }
}

public enum StringFormats: String, Equatable, Codable {
    case utf8, utf16_big, ascii_big, unicode_big
    case utf16_little, ascii_little, unicode_little
    case gsColo, gsXD, gsPBR, gs
    
    public var characterLength: Int {
        switch self {
        case .utf8: return 1
        case .ascii_big, .ascii_little: return 1
        case .utf16_big, .utf16_little: return 2
        case .unicode_big, .unicode_little: return 2
        default: return 2
        }
    }
    
    public var encoding: String.Encoding {
        switch self {
        case .utf8: return .utf8
        case .ascii_big, .ascii_little: return .ascii
        case .utf16_big, .utf16_little: return .utf16
        case .unicode_big, .unicode_little: return .unicode
        case .gs, .gsColo, .gsXD, .gsPBR: return.utf16
        }
    }
    
    public var byteOrder: ByteOrder {
        switch self {
        case .utf16_little, .ascii_little, .unicode_little: return .little
        case .utf16_big, .ascii_big, .unicode_big: return .big
        case .gsColo, .gsXD, .gsPBR, .gs: return .big
        case .utf8: return .unspecified
        }
    }
}

extension String {
    public func hexValue() -> Int? {
        guard self.isHexInteger else { return nil }
        
        let digits = self.replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "-", with: "")
        let isNegative = self.first == "-"
        let magnitude = Int(strtoul(digits, nil, 16)) // converts hex string to uint and then cast as Int
        return isNegative ? -magnitude : magnitude
    }
    
    public var isHexInteger: Bool {
        guard self.count > 0 else {
            return false
        }
        var digits = self
        if digits.count > 1, digits.substring(from: 0, to: 1) == "-" {
            digits = digits.substring(from: 1)
        }
        if digits.count > 2, digits.substring(from: 0, to: 2) == "0x" {
            digits = digits.substring(from: 2, to: count)
        }
        return digits.map { $0.isHexDigit }.reduce(true) { partialResult, nextBool in
            return partialResult && nextBool
        }
    }
    
    public var integerValue: Int? {
        if count == 0 {
            return nil
        }
        if let integer = Int(self) {
            return integer
        }
        return hexValue()
    }

    public var doubleValue: Double? {
        if count == 0 {
            return nil
        }
        return  Double(self)
    }
}

extension String {
    public var lines: [String] {
        return self.split(separator: "\n").map { String($0) }
    }
}
