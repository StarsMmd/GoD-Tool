//
//  GSString.swift
//  
//
//  Created by Stars Momodu on 29/05/2022.
//

import Foundation

public struct GSString {
    private var characterList = [GSCharacter]()
    public var count: Int { characterList.count }
    
    internal init(characters: [GSCharacter]) {
        self.characterList = characters
    }
    
    public init() {}
    
    public init(string: String, format: StringFormats = .gs) {
        var specialCharacter: String?
        for character in string.replacingOccurrences(of: "\n", with: "{New Line}") {
            switch character {
            case "{":
                if specialCharacter == nil {
                    specialCharacter = "{"
                }
            case "}":
                if let sp = specialCharacter,
                   let newChar = GSCharacter(string: sp + "}", format: format) {
                    characterList.append(newChar)
                }
                specialCharacter = nil
            default:
                if let sp = specialCharacter {
                    specialCharacter = sp + String(character)
                } else {
                    if let newChar = GSCharacter(string: String(character), format: format) {
                        characterList.append(newChar)
                    }
                }
            }
        }
    }
}

extension GSString {
    public var characters: [String] {
        return characterList.map { $0.string(format: .gs) }
    }
    
    public func string(format: StringFormats) -> String {
        return characterList.map { $0.string(format: format) }.joined(separator: "")
    }
}

extension GSString: CustomStringConvertible, ExpressibleByStringLiteral {
    public var description: String {
        return string(format: .gs)
    }
    
    public typealias StringLiteralType = String
    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value)
    }
}

extension GSString: DataConvertible {
    public var rawData: GoDData {
        return characterList.map { $0.rawData }.reduce(GoDData()) { partialResult, nextValue in
            let nextPartialResult = partialResult
            nextPartialResult.append(nextValue)
            return nextPartialResult
        }
    }
}

extension GSString: ExpressibleByData {
    public init?(data: GoDData) {
        guard let str = data.readGSString(atAddress: 0, format: .gs) else {
            return nil
        }
        self = str
    }
}

extension GSString: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string(format: .gs))
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self.init(string: string)
    }
}

extension GSString: Equatable {}
