//
//  GSStringTests.swift
//  
//
//  Created by Stars Momodu on 30/05/2022.
//

import Foundation

import XCTest
@testable import GoDFoundation

class GSStringTests: XCTestCase {
 
    func testLiteral() {
        let sut: GSString = "Test String 1"
        XCTAssertEqual(sut.string(format: .utf8), "Test String 1")
    }
    
    func testSpecial() {
        let sut: GSString = "Test\nline"
        XCTAssertEqual(sut.count, 9)
        let sut2: GSString = "Test{00 00 00 00 00 00}line"
        XCTAssertEqual(sut2.count, 9)
        let sut3: GSString = GSString(string: "Test{Battle Player}line", format: .gsColo)
        XCTAssertEqual(sut3.count, 9)
    }
    
    func testNewLine() {
        let sut: GSString = GSString(string: "\n", format: .gsColo)
        let sut2: GSString = GSString(string: "\n", format: .gsXD)
        let sut3: GSString = GSString(string: "\n", format: .gsPBR)
        let sut4: GSString = GSString(string: "\n", format: .gs)
//        XCTAssertEqual(sut.rawData.rawBytes, [0xFF, 0xFF, 0x00])
//        XCTAssertEqual(sut2.rawData.rawBytes, [0xFF, 0xFF, 0x00])
//        XCTAssertEqual(sut3.rawData.rawBytes, [0xFF, 0xFF, 0xFF, 0xFE])
        XCTAssertEqual(sut4.rawData.rawBytes, [0x00, 0x0A])
        XCTAssertEqual(sut.string(format: .gsColo), "\n")
        XCTAssertEqual(sut2.string(format: .gsXD), "\n")
        XCTAssertEqual(sut3.string(format: .gsPBR), "\n")
        XCTAssertEqual(sut4.string(format: .gs), "\n")
        
        let sut5 = GSString(characters: [.special([0x00])])
        let sut6 = GSString(characters: [.special([0xFF, 0xFE])])
        XCTAssertEqual(sut5.rawData.rawBytes, [0xFF, 0xFF, 0x00])
        XCTAssertEqual(sut6.rawData.rawBytes, [0xFF, 0xFF, 0xFF, 0xFE])
        XCTAssertEqual(sut5.string(format: .gsColo), "\n")
        XCTAssertEqual(sut5.string(format: .gsXD), "\n")
        XCTAssertEqual(sut6.string(format: .gsPBR), "\n")
        XCTAssertEqual(sut5.string(format: .gs), "{00}")
    }
    
    func testClear() {
        let sut: GSString = GSString(string: "{Clear}", format: .gsColo)
        let sut2: GSString = GSString(string: "{Clear}", format: .gsXD)
        let sut3: GSString = GSString(string: "{Clear}", format: .gs)
        XCTAssertEqual(sut.rawData.rawBytes, [0xFF, 0xFF, 0x03])
        XCTAssertEqual(sut2.rawData.rawBytes, [0xFF, 0xFF, 0x03])
        XCTAssertEqual(sut.string(format: .gsColo), "{Clear}")
        XCTAssertEqual(sut2.string(format: .gsXD), "{Clear}")
        XCTAssertEqual(sut3.string(format: .gs), "")
        
        let sut4 = GSString(characters: [.special([0x03])])
        XCTAssertEqual(sut4.rawData.rawBytes, [0xFF, 0xFF, 0x03])
        XCTAssertEqual(sut4.string(format: .gsColo), "{Clear}")
        XCTAssertEqual(sut4.string(format: .gsXD), "{Clear}")
        XCTAssertEqual(sut4.string(format: .gs), "{03}")
    }
    
    func testFontBold() {
        let sut: GSString = GSString(string: "{Font Bold}", format: .gsColo)
        let sut2: GSString = GSString(string: "{Font Bold}", format: .gsXD)
        let sut3: GSString = GSString(string: "{Font Bold}", format: .gs)
        XCTAssertEqual(sut.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x01])
        XCTAssertEqual(sut2.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x01])
        XCTAssertEqual(sut.string(format: .gsColo), "{Font Bold}")
        XCTAssertEqual(sut2.string(format: .gsXD), "{Font Bold}")
        XCTAssertEqual(sut3.string(format: .gs), "")
        
        let sut4 = GSString(characters: [.special([0x07, 0x01])])
        XCTAssertEqual(sut4.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x01])
        XCTAssertEqual(sut4.string(format: .gsColo), "{Font Bold}")
        XCTAssertEqual(sut4.string(format: .gsXD), "{Font Bold}")
        XCTAssertEqual(sut4.string(format: .gs), "{07 01}")
    }
    
    func testFontRegular() {
        let sut: GSString = GSString(string: "{Font Regular}", format: .gsColo)
        let sut2: GSString = GSString(string: "{Font Regular}", format: .gsXD)
        let sut3: GSString = GSString(string: "{Font Regular}", format: .gs)
        XCTAssertEqual(sut.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x03])
        XCTAssertEqual(sut2.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x03])
        XCTAssertEqual(sut.string(format: .gsColo), "{Font Regular}")
        XCTAssertEqual(sut2.string(format: .gsXD), "{Font Regular}")
        XCTAssertEqual(sut3.string(format: .gs), "")
        
        let sut4 = GSString(characters: [.special([0x07, 0x03])])
        XCTAssertEqual(sut4.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x03])
        XCTAssertEqual(sut4.string(format: .gsColo), "{Font Regular}")
        XCTAssertEqual(sut4.string(format: .gsXD), "{Font Regular}")
        XCTAssertEqual(sut4.string(format: .gs), "{07 03}")
    }
    
    func testFontSuperscript1() {
        let sut: GSString = GSString(string: "{Font Super 1}", format: .gsColo)
        let sut2: GSString = GSString(string: "{Font Super 1}", format: .gsXD)
        let sut3: GSString = GSString(string: "{Font Super 1}", format: .gs)
        XCTAssertEqual(sut.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x02])
        XCTAssertEqual(sut2.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x02])
        XCTAssertEqual(sut.string(format: .gsColo), "{Font Super 1}")
        XCTAssertEqual(sut2.string(format: .gsXD), "{Font Super 1}")
        XCTAssertEqual(sut3.string(format: .gs), "")
        
        let sut4 = GSString(characters: [.special([0x07, 0x02])])
        XCTAssertEqual(sut4.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x02])
        XCTAssertEqual(sut4.string(format: .gsColo), "{Font Super 1}")
        XCTAssertEqual(sut4.string(format: .gsXD), "{Font Super 1}")
        XCTAssertEqual(sut4.string(format: .gs), "{07 02}")
    }
    
    func testFontSuperscript2() {
        let sut: GSString = GSString(string: "{Font Super 2}", format: .gsColo)
        let sut2: GSString = GSString(string: "{Font Super 2}", format: .gsXD)
        let sut3: GSString = GSString(string: "{Font Super 2}", format: .gs)
        XCTAssertEqual(sut.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x04])
        XCTAssertEqual(sut2.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x04])
        XCTAssertEqual(sut.string(format: .gsColo), "{Font Super 2}")
        XCTAssertEqual(sut2.string(format: .gsXD), "{Font Super 2}")
        XCTAssertEqual(sut3.string(format: .gs), "")
        
        let sut4 = GSString(characters: [.special([0x07, 0x04])])
        XCTAssertEqual(sut4.rawData.rawBytes, [0xFF, 0xFF, 0x07, 0x04])
        XCTAssertEqual(sut4.string(format: .gsColo), "{Font Super 2}")
        XCTAssertEqual(sut4.string(format: .gsXD), "{Font Super 2}")
        XCTAssertEqual(sut4.string(format: .gs), "{07 04}")
    }
    
    func testColor() {
        let sut: GSString = GSString(string: "{Color: #A0CFB8}", format: .gsColo)
        let sut2: GSString = GSString(string: "{Color: #A0CFB8}", format: .gsXD)
        let sut3: GSString = GSString(string: "{Color: #A0CFB8}", format: .gs)
        XCTAssertEqual(sut.rawData.rawBytes, [0xFF, 0xFF, 0x08, 0xA0, 0xCF, 0xB8, 0xFF])
        XCTAssertEqual(sut2.rawData.rawBytes, [0xFF, 0xFF, 0x08, 0xA0, 0xCF, 0xB8, 0xFF])
        XCTAssertEqual(sut.string(format: .gsColo), "{Color: #A0CFB8}")
        XCTAssertEqual(sut2.string(format: .gsXD), "{Color: #A0CFB8}")
        XCTAssertEqual(sut3.string(format: .gs), "")
        
        let sut4 = GSString(characters: [.special([0x08, 0xA0, 0xCF, 0xB8, 0xFF])])
        XCTAssertEqual(sut4.rawData.rawBytes, [0xFF, 0xFF, 0x08, 0xA0, 0xCF, 0xB8, 0xFF])
        XCTAssertEqual(sut4.string(format: .gsColo), "{Color: #A0CFB8}")
        XCTAssertEqual(sut4.string(format: .gsXD), "{Color: #A0CFB8}")
        XCTAssertEqual(sut4.string(format: .gs), "{08 A0 CF B8 FF}")
    }
}
