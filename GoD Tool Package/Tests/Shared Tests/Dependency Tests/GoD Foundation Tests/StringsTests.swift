//
//  StringsTests.swift
//  
//
//  Created by Stars Momodu on 30/05/2022.
//

import XCTest
@testable import GoDFoundation

class StringsTests: XCTestCase {
    
    func testSubstring() {
        let sut = "abcdefghijklmnopqrstuvwxyz"
        let sub1 = sut.substring(from: 0, to: 5)
        let sub2 = sut.substring(from: 17, to: 22)
        let sub3 = sut.substring(from: -5, to: 1)
        let sub4 = sut.substring(from: 25, to: 29)
        let sub5 = sut.substring(from: -1)
        let sub6 = sut.substring(from: 23, to: -1)
        let sub7 = sut.substring(from: 22)
        XCTAssertEqual(sub1, "abcde")
        XCTAssertEqual(sub2, "rstuv")
        XCTAssertEqual(sub3, "")
        XCTAssertEqual(sub4, "z")
        XCTAssertEqual(sub5, "z")
        XCTAssertEqual(sub6, "xy")
        XCTAssertEqual(sub7, "wxyz")
    }
    
    func testStartsWith() {
        let sut = "abcdefghijklmnopqrstuvwxyz"
        let start1 = sut.startsWith("")
        let start2 = sut.startsWith("a")
        let start3 = sut.startsWith("abcde")
        let start4 = sut.startsWith("abcdefghijklmnopqrstuvwxy")
        let start5 = sut.startsWith("abcdefghijklmnopqrstuvwxyz")
        let start6 = sut.startsWith("b")
        let start7 = sut.startsWith("z")
        let start8 = sut.startsWith("abcdeg")
        XCTAssertTrue(start1)
        XCTAssertTrue(start2)
        XCTAssertTrue(start3)
        XCTAssertTrue(start4)
        XCTAssertTrue(start5)
        XCTAssertFalse(start6)
        XCTAssertFalse(start7)
        XCTAssertFalse(start8)
    }
    
    func testEndsWith() {
        let sut = "abcdefghijklmnopqrstuvwxyz"
        let end1 = sut.endsWith("")
        let end2 = sut.endsWith("z")
        let end3 = sut.endsWith("vwxyz")
        let end4 = sut.endsWith("bcdefghijklmnopqrstuvwxyz")
        let end5 = sut.endsWith("abcdefghijklmnopqrstuvwxyz")
        let end6 = sut.endsWith("y")
        let end7 = sut.endsWith("a")
        let end8 = sut.endsWith("tvwxyz")
        XCTAssertTrue(end1)
        XCTAssertTrue(end2)
        XCTAssertTrue(end3)
        XCTAssertTrue(end4)
        XCTAssertTrue(end5)
        XCTAssertFalse(end6)
        XCTAssertFalse(end7)
        XCTAssertFalse(end8)
    }
    
    func testIntegerValue() {
        let sut = "1450"
        XCTAssertEqual(sut.integerValue, 1450)
        let sut2 = "1h67"
        XCTAssertNil(sut2.integerValue)
        let sut3 = "-6371"
        XCTAssertEqual(sut3.integerValue, -6371)
        let sut4 = "-1h67"
        XCTAssertNil(sut4.integerValue)
    }
    
    func testHexIntegerValue() {
        let sut = "120"
        let sut2 = "1AB"
        let sut3 = "0x742"
        let sut4 = "0x8CE"
        let sut5 = "0xd4f"
        let sut6 = "AbC"
        let sut7 = "A0G"
        let sut8 = "0xT87"
        let sut9 = ""
        XCTAssertTrue(sut.isHexInteger)
        XCTAssertEqual(sut.hexValue(), 0x120)
        XCTAssertTrue(sut2.isHexInteger)
        XCTAssertEqual(sut2.hexValue(), 0x1AB)
        XCTAssertTrue(sut3.isHexInteger)
        XCTAssertEqual(sut3.hexValue(), 0x742)
        XCTAssertTrue(sut4.isHexInteger)
        XCTAssertEqual(sut4.hexValue(), 0x8CE)
        XCTAssertTrue(sut5.isHexInteger)
        XCTAssertEqual(sut5.hexValue(), 0xD4F)
        XCTAssertTrue(sut6.isHexInteger)
        XCTAssertEqual(sut6.hexValue(), 0xABC)
        XCTAssertFalse(sut7.isHexInteger)
        XCTAssertNil(sut7.hexValue())
        XCTAssertFalse(sut8.isHexInteger)
        XCTAssertNil(sut8.hexValue())
        XCTAssertFalse(sut9.isHexInteger)
        XCTAssertNil(sut9.hexValue())
    }
    
    func testNegativeHexIntegerValue() {
        let sut = "-120"
        let sut2 = "-1AB"
        let sut3 = "-0x742"
        let sut4 = "-0x8CE"
        let sut5 = "-0xd4f"
        let sut6 = "-AbC"
        let sut7 = "-A0G"
        let sut8 = "-0xT87"
        let sut9 = "-"
        XCTAssertTrue(sut.isHexInteger)
        XCTAssertEqual(sut.hexValue(), -0x120)
        XCTAssertTrue(sut2.isHexInteger)
        XCTAssertEqual(sut2.hexValue(), -0x1AB)
        XCTAssertTrue(sut3.isHexInteger)
        XCTAssertEqual(sut3.hexValue(), -0x742)
        XCTAssertTrue(sut4.isHexInteger)
        XCTAssertEqual(sut4.hexValue(), -0x8CE)
        XCTAssertTrue(sut5.isHexInteger)
        XCTAssertEqual(sut5.hexValue(), -0xD4F)
        XCTAssertTrue(sut6.isHexInteger)
        XCTAssertEqual(sut6.hexValue(), -0xABC)
        XCTAssertFalse(sut7.isHexInteger)
        XCTAssertNil(sut7.hexValue())
        XCTAssertFalse(sut8.isHexInteger)
        XCTAssertNil(sut8.hexValue())
        XCTAssertFalse(sut9.isHexInteger)
        XCTAssertNil(sut9.hexValue())
    }
}
