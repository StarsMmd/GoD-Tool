//
//  GSCharacter.swift
//  
//
//  Created by Stars Momodu on 29/05/2022.
//

import Foundation

enum GSCharacter {
    case raw(String)
    case special([UInt8])
}

extension GSCharacter: DataConvertible {
    var rawData: GoDData {
        switch self {
        case .raw(let s): return GoDData(character: s, format: .gs)
        case .special(let bytes): return GoDData(byteStream: [0xFF, 0xFF] + bytes)
        }
    }
}

extension GSCharacter {
    func string(format: StringFormats) -> String {
        switch (format, self) {
        case (_ , .raw(let s)): return s
        case (.gsColo, .special([0])), (.gsXD, .special([0])), (.gsPBR, .special([0xFF, 0xFE])): return "\n"
        case (.gsColo, .special([2])), (.gsXD, .special([2])): return "{Await Input}"
        case (.gsColo, .special([3])), (.gsXD, .special([3])): return "{Clear}"
        case (.gsColo, .special([4])), (.gsXD, .special([4])): return "{Kanji Start}"
        case (.gsColo, .special([5])), (.gsXD, .special([5])): return "{Furigana Start}"
        case (.gsColo, .special([6])), (.gsXD, .special([6])): return "{Furigana End}"
        case (.gsColo, .special([7, 1])), (.gsXD, .special([7, 1])): return "{Font Bold}"
        case (.gsColo, .special([7, 2])), (.gsXD, .special([7, 2])): return "{Font Super 1}"
        case (.gsColo, .special([7, 3])), (.gsXD, .special([7, 3])): return "{Font Regular}"
        case (.gsColo, .special([7, 4])), (.gsXD, .special([7, 4])): return "{Font Super 2}"
        case (.gsColo, .special(let bytes)) where bytes.count == 5 && bytes[0] == 8:
            fallthrough
        case (.gsXD, .special(let bytes)) where bytes.count == 5 && bytes[0] == 8: return "{Color: #\(bytes[1].hex())\(bytes[2].hex())\(bytes[3].hex())}"
        case (.gsColo, .special(let bytes)) where bytes.count == 2 && bytes[0] == 9:
            fallthrough
        case (.gsXD, .special(let bytes)) where bytes.count == 2 && bytes[0] == 9: return "{Pause: \(bytes[1])}"
        case (.gsColo, .special([0x13])), (.gsXD, .special([0x13])): return "{Battle Player}"
        case (.gsColo, .special([0x14])), (.gsXD, .special([0x14])): return "{Sent Out Pokemon 1}"
        case (.gsColo, .special([0x15])), (.gsXD, .special([0x15])): return "{Sent Out Pokemon 2}"
        case (.gsColo, .special([0x22])), (.gsXD, .special([0x22])): return "{Foe Trainer Class}"
        case (.gsColo, .special([0x23])), (.gsXD, .special([0x23])): return "{Foe Trainer Name}"
        case (.gsColo, .special([0x2B])), (.gsXD, .special([0x2B])): return "{Field Player}"
        case (.gsColo, .special([0x2C])): return "{Rui}"
        case (.gsColo, .special([0x38, 0])), (.gsXD, .special([0x38, 0])): return "{White}"
        case (.gsColo, .special([0x38, 1])), (.gsXD, .special([0x38, 1])): return "{Yellow}"
        case (.gsColo, .special([0x38, 2])), (.gsXD, .special([0x38, 2])): return "{Green}"
        case (.gsColo, .special([0x38, 3])), (.gsXD, .special([0x38, 3])): return "{Blue}"
        case (.gsColo, .special([0x38, 4])), (.gsXD, .special([0x38, 4])): return "{Yellow 2}"
        case (.gsColo, .special([0x38, 5])), (.gsXD, .special([0x38, 5])): return "{Black}"
        case (.gsColo, .special([0x50])), (.gsXD, .special([0x50])): return "{Var Species Cry}"
        case (.gsColo, .special([0x59])), (.gsXD, .special([0x59])): return "{Speaker}"
        case (.gsColo, .special([0x6A])), (.gsXD, .special([0x6A])): return "{Set Speaker}"
        case (.gsColo, .special([0x6D])), (.gsXD, .special([0x6D])): return "{Await Input 2}"
            
        case (.gsPBR, .special(let bytes)) where bytes.count > 4 && bytes[0...1] == [0,1]:
            let kanaCount = Int(bytes[2])
            let kanjiCount = Int(bytes[3])
            let characterCount = kanaCount + kanjiCount
            if bytes.count == 4 + (characterCount * 2) {
                let kanaBytes = Array(bytes[4 ..< 4 + (kanaCount * 2)])
                let kanaData = GoDData(byteStream: kanaBytes)
                let kanjiBytes = Array(bytes[4 + (kanaCount * 2) ..< 4 + (kanaCount * 2) + (kanjiCount * 2)])
                let kanjiData = GoDData(byteStream: kanjiBytes)
                return "{Furigana: \(kanaData.string(format: StringFormats.utf16_big)) \(kanjiData.string(format: StringFormats.utf16_big))}"
            }
        case (.gsPBR, .special(let bytes)) where bytes.count == 4 && bytes[0...1] == [0,2]:
            let durationBytes = Array(bytes[2 ..< 4])
            let durationData = GoDData(byteStream: durationBytes)
            return "{Pause: \(UInt16(data: durationData) ?? 0)}"
        case (.gsPBR, .special([0xFF, 0xFF])):
            return "{End}"
            
        case (_, .special(let bytes)):
            guard bytes.count > 0 else { return "" }
            var string = ""
            for byte in bytes {
                string += byte.hex() + " "
            }
            if string.last == " " {
                string.removeLast()
            }
            return "{" + string + "}"
        }
        
        return ""
    }
}

extension GSCharacter {
    init?(string: String, format: StringFormats) {
        switch format {
        case .gsColo, .gsXD:
            if string == "\n" { self = .special([0x00]); return }
            if string == "{New Line}" { self = .special([0x00]); return }
            if string == "{Await Input}" { self = .special([0x02]); return }
            if string == "{Clear}" { self = .special([0x03]); return }
            if string == "{Kanji Start}" { self = .special([0x04]); return }
            if string == "{Furigana Start}" { self = .special([0x05]); return }
            if string == "{Furigana End}" { self = .special([0x06]); return }
            if string == "{Font Bold}" { self = .special([0x07, 0x01]); return }
            if string == "{Font Super 1}" { self = .special([0x07, 0x02]); return }
            if string == "{Font Regular}" { self = .special([0x07, 0x03]); return }
            if string == "{Font Super 2}" { self = .special([0x07, 0x04]); return }
            if string.startsWith("{Color: #"), string.endsWith("}") {
                var substring = string.substring(from: "{Color: #".count)
                substring = substring.substring(from: 0, to: -1)
                guard substring.count == 6 else { return nil }
                let red = UInt8(substring.substring(from: 0, to: 2).hexValue() ?? 0)
                let green = UInt8(substring.substring(from: 2, to: 4).hexValue() ?? 0)
                let blue = UInt8(substring.substring(from: 4, to: 6).hexValue() ?? 0)
                self = .special([0x08, red, green, blue, 0xFF]); return
            }
            if string.startsWith("{Pause: "), string.endsWith("}") {
                var substring = string.substring(from: "{Pause: ".count)
                substring = substring.substring(from: 0, to: -1)
                guard let duration = substring.integerValue else { return nil }
                self = .special([0x09, UInt8(duration & 0xFF)]); return
            }
            if string == "{Battle Player}" { self = .special([0x13]); return }
            if string == "{Sent Out Pokemon 1}" { self = .special([0x14]); return }
            if string == "{Sent Out Pokemon 2}" { self = .special([0x15]); return }
            if string == "{Foe Trainer Class}" { self = .special([0x22]); return }
            if string == "{Foe Trainer Name}" { self = .special([0x23]); return }
            if string == "{Field Player}" { self = .special([0x2B]); return }
            if string == "{Rui}" { self = .special([0x2C]); return }
            if string == "{White}" { self = .special([0x38, 0x00]); return }
            if string == "{Yellow}" { self = .special([0x38, 0x01]); return }
            if string == "{Green}" { self = .special([0x38, 0x02]); return }
            if string == "{Blue}" { self = .special([0x38, 0x03]); return }
            if string == "{Yellow 2}" { self = .special([0x38, 0x04]); return }
            if string == "{Black}" { self = .special([0x38, 0x05]); return }
            if string == "{Var Species Cry}" { self = .special([0x50]); return }
            if string == "{Speaker}" { self = .special([0x59]); return }
            if string == "{Set Speaker}" { self = .special([0x6A]); return }
            if string == "{Await Input 2}" { self = .special([0x6D]); return }
            
        case .gsPBR:
            if string == "\n" { self = .special([0xFF, 0xFE]); return }
            if string == "{New Line}" { self = .special([0xFF, 0xFE]); return }
            if string == "{End}" { self = .special([0xFF, 0xFF]); return }
            
            if string.startsWith("{Furigana: "), string.endsWith("}") {
                var substring = string.substring(from: "{Furigana: ".count)
                substring = substring.substring(from: 0, to: -1)
                let parts = substring.split(separator: " ")
                if parts.count == 2 {
                    let kanji = String(parts[0])
                    let kana = String(parts[1])
                    let data = GoDData()
                    data.append(UInt16(1))
                    data.append(UInt8(kanji.count & 0xFF))
                    data.append(UInt8(kana.count & 0xFF))
                    for char in kanji {
                        data.append(GoDData(string: String(char), format: .utf16_big))
                    }
                    for char in kana {
                        data.append(GoDData(string: String(char), format: .utf16_big))
                    }
                    guard let bytes = [UInt8](data: data) else {
                        return nil
                    }
                    self = .special(bytes); return
                }
            }
            if string.startsWith("{Pause: "), string.endsWith("}") {
                var substring = string.substring(from: "{Pause: ".count)
                substring = substring.substring(from: 0, to: -1)
                if let duration = substring.integerValue {
                    let data = GoDData()
                    data.append(UInt16(2))
                    data.append(UInt16(duration & 0xFFFF))
                    guard let bytes = [UInt8](data: data) else {
                        return nil
                    }
                    self = .special(bytes); return
                }
            }
        default:
            if string == "{New Line}" { self = .raw("\n"); return }
        }
        
        if string.startsWith("{"), string.endsWith("}") {
            let substring = string.substring(from: 1, to: -1)
            var bytes = [UInt8]()
            let byteStrings = substring.split(separator: " ")
            for byteString in byteStrings {
                if byteString.count == 2,
                   let value = String(byteString).hexValue() {
                    bytes.append(UInt8(value & 0xFF))
                }
            }
            self = .special(bytes); return
        }
        if string.count == 1 {
            self = .raw(string); return
        }
        return nil
    }
}

extension GSCharacter: Equatable {}
