//
//  IntegerConversionTests.swift
//  
//
//  Created by Stars Momodu on 10/06/2022.
//

import Foundation
import XCTest
@testable import GoDFoundation

class IntegerConversionTests: XCTestCase {
    
    func testToInt0() {
        let sut1: UInt8 = 0
        let sut2: Int8 = 0
        let sut3: UInt16 = 0
        let sut4: Int16 = 0
        let sut5: UInt32 = 0
        let sut6: Int32 = 0
        XCTAssertEqual(sut1.asInt, 0)
        XCTAssertEqual(sut2.asInt, 0)
        XCTAssertEqual(sut3.asInt, 0)
        XCTAssertEqual(sut4.asInt, 0)
        XCTAssertEqual(sut5.asInt, 0)
        XCTAssertEqual(sut6.asInt, 0)
        let arraySut1: [UInt8] = [0,0,0,0]
        let arraySut2: [Int8] = [0,0,0,0]
        let arraySut3: [UInt16] = [0,0]
        let arraySut4: [Int16] = [0,0]
        let arraySut5: [UInt32] = [0]
        let arraySut6: [Int32] = [0]
        XCTAssertEqual(arraySut1.asInt, 0)
        XCTAssertEqual(arraySut2.asInt, 0)
        XCTAssertEqual(arraySut3.asInt, 0)
        XCTAssertEqual(arraySut4.asInt, 0)
        XCTAssertEqual(arraySut5.asInt, 0)
        XCTAssertEqual(arraySut6.asInt, 0)
    }
    
    func testFromInt0() {
        let sut1: UInt8 = .init(integer: 0)
        let sut2: Int8 = .init(integer: 0)
        let sut3: UInt16 = .init(integer: 0)
        let sut4: Int16 = .init(integer: 0)
        let sut5: UInt32 = .init(integer: 0)
        let sut6: Int32 = .init(integer: 0)
        XCTAssertEqual(sut1, 0)
        XCTAssertEqual(sut2, 0)
        XCTAssertEqual(sut3, 0)
        XCTAssertEqual(sut4, 0)
        XCTAssertEqual(sut5, 0)
        XCTAssertEqual(sut6, 0)
        let arraySut1: [UInt8] = .init(integer: 0)
        let arraySut2: [Int8] = .init(integer: 0)
        let arraySut3: [UInt16] = .init(integer: 0)
        let arraySut4: [Int16] = .init(integer: 0)
        let arraySut5: [UInt32] = .init(integer: 0)
        let arraySut6: [Int32] = .init(integer: 0)
        XCTAssertEqual(arraySut1, [0,0,0,0])
        XCTAssertEqual(arraySut2, [0,0,0,0])
        XCTAssertEqual(arraySut3, [0,0])
        XCTAssertEqual(arraySut4, [0,0])
        XCTAssertEqual(arraySut5, [0])
        XCTAssertEqual(arraySut6, [0])
    }
    
    func testToIntMax() {
        let sut1: UInt8 = 0xFF
        let sut2: Int8 = 0x7F
        let sut3: UInt16 = 0xFFFF
        let sut4: Int16 = 0x7FFF
        let sut5: UInt32 = 0xFFFFFFFF
        let sut6: Int32 = 0x7FFFFFFF
        XCTAssertEqual(sut1.asInt, 0xFF)
        XCTAssertEqual(sut2.asInt, 0x7F)
        XCTAssertEqual(sut3.asInt, 0xFFFF)
        XCTAssertEqual(sut4.asInt, 0x7FFF)
        XCTAssertEqual(sut5.asInt, 0xFFFFFFFF)
        XCTAssertEqual(sut6.asInt, 0x7FFFFFFF)
        let arraySut1: [UInt8] = [0xFF,0xFF,0xFF,0xFF]
        let arraySut2: [UInt16] = [0xFFFF,0xFFFF]
        let arraySut3: [UInt32] = [0xFFFFFFFF]
        XCTAssertEqual(arraySut1.asInt, 0xFFFFFFFF)
        XCTAssertEqual(arraySut2.asInt, 0xFFFFFFFF)
        XCTAssertEqual(arraySut3.asInt, 0xFFFFFFFF)
    }
    
    func testFromIntMax() {
        let sut1: UInt8 = .init(integer: 0xFF)
        let sut2: Int8 = .init(integer: 0x7F)
        let sut3: UInt16 = .init(integer: 0xFFFF)
        let sut4: Int16 = .init(integer: 0x7FFF)
        let sut5: UInt32 = .init(integer: 0xFFFFFFFF)
        let sut6: Int32 = .init(integer: 0x7FFFFFFF)
        XCTAssertEqual(sut1, 0xFF)
        XCTAssertEqual(sut2, 0x7F)
        XCTAssertEqual(sut3, 0xFFFF)
        XCTAssertEqual(sut4, 0x7FFF)
        XCTAssertEqual(sut5, 0xFFFFFFFF)
        XCTAssertEqual(sut6, 0x7FFFFFFF)
        let arraySut1: [UInt8] = .init(integer: 0xFFFFFFFF)
        let arraySut2: [UInt16] = .init(integer: 0xFFFFFFFF)
        let arraySut3: [UInt32] = .init(integer: 0xFFFFFFFF)
        XCTAssertEqual(arraySut1, [0xFF,0xFF,0xFF,0xFF])
        XCTAssertEqual(arraySut2, [0xFFFF,0xFFFF])
        XCTAssertEqual(arraySut3, [0xFFFFFFFF])
    }
    
    func testToIntMin() {
        let sut1: Int8 = -0x80
        let sut2: Int16 = -0x8000
        let sut3: Int32 = -0x80000000
        XCTAssertEqual(sut1.asInt, -0x80)
        XCTAssertEqual(sut2.asInt, -0x8000)
        XCTAssertEqual(sut3.asInt, -0x80000000)
    }
    
    func testFromIntMin() {
        let sut1: Int8 = .init(integer: 0x80)
        let sut2: Int16 = .init(integer: 0x8000)
        let sut3: Int32 = .init(integer: 0x80000000)
        XCTAssertEqual(sut1, -0x80)
        XCTAssertEqual(sut2, -0x8000)
        XCTAssertEqual(sut3, -0x80000000)
    }
    
    func testToInt1() {
        let sut1: UInt8 = 1
        let sut2: Int8 = 1
        let sut3: UInt16 = 1
        let sut4: Int16 = 1
        let sut5: UInt32 = 1
        let sut6: Int32 = 1
        XCTAssertEqual(sut1.asInt, 1)
        XCTAssertEqual(sut2.asInt, 1)
        XCTAssertEqual(sut3.asInt, 1)
        XCTAssertEqual(sut4.asInt, 1)
        XCTAssertEqual(sut5.asInt, 1)
        XCTAssertEqual(sut6.asInt, 1)
        let arraySut1: [UInt8] = [0, 0, 0, 1]
        let arraySut2: [UInt16] = [0, 1]
        let arraySut3: [UInt32] = [1]
        XCTAssertEqual(arraySut1.asInt, 1)
        XCTAssertEqual(arraySut2.asInt, 1)
        XCTAssertEqual(arraySut3.asInt, 1)
    }
    
    func testFromInt1() {
        let sut1: UInt8 = .init(integer: 1)
        let sut2: Int8 = .init(integer: 1)
        let sut3: UInt16 = .init(integer: 1)
        let sut4: Int16 = .init(integer: 1)
        let sut5: UInt32 = .init(integer: 1)
        let sut6: Int32 = .init(integer: 1)
        XCTAssertEqual(sut1, 1)
        XCTAssertEqual(sut2, 1)
        XCTAssertEqual(sut3, 1)
        XCTAssertEqual(sut4, 1)
        XCTAssertEqual(sut5, 1)
        XCTAssertEqual(sut6, 1)
        let arraySut1: [UInt8] = .init(integer: 1)
        let arraySut2: [UInt16] = .init(integer: 1)
        let arraySut3: [UInt32] = .init(integer: 1)
        XCTAssertEqual(arraySut1, [ 0, 0, 0, 1])
        XCTAssertEqual(arraySut2, [0, 1])
        XCTAssertEqual(arraySut3, [1])
    }
    
    func testToIntMinus1() {
        let sut1: Int8 = -1
        let sut2: Int16 = -1
        let sut3: Int32 = -1
        XCTAssertEqual(sut1.asInt, -1)
        XCTAssertEqual(sut2.asInt, -1)
        XCTAssertEqual(sut3.asInt, -1)
    }
    
    func testFromIntMinus1() {
        let sut1: UInt8 = .init(integer: -1)
        let sut2: Int8 = .init(integer: -1)
        let sut3: UInt16 = .init(integer: -1)
        let sut4: Int16 = .init(integer: -1)
        let sut5: UInt32 = .init(integer: -1)
        let sut6: Int32 = .init(integer: -1)
        XCTAssertEqual(sut1, 0xFF)
        XCTAssertEqual(sut2, -1)
        XCTAssertEqual(sut3, 0xFFFF)
        XCTAssertEqual(sut4, -1)
        XCTAssertEqual(sut5, 0xFFFFFFFF)
        XCTAssertEqual(sut6, -1)
        let arraySut1: [UInt8] = .init(integer: -1)
        let arraySut2: [UInt16] = .init(integer: -1)
        let arraySut3: [UInt32] = .init(integer: -1)
        XCTAssertEqual(arraySut1, [0xFF, 0xFF, 0xFF, 0xFF])
        XCTAssertEqual(arraySut2, [0xFFFF, 0xFFFF])
        XCTAssertEqual(arraySut3, [0xFFFFFFFF])
    }
    
    func testToIntArray() {
        let arraySut1: [UInt8] = [0x12, 0x34, 0x56, 0x78]
        let arraySut2: [UInt16] = [0x1234, 0x5678]
        let arraySut3: [UInt32] = [0x12345678]
        XCTAssertEqual(arraySut1.asInt, 0x12345678)
        XCTAssertEqual(arraySut2.asInt, 0x12345678)
        XCTAssertEqual(arraySut3.asInt, 0x12345678)
    }
    
    func testFromIntArray() {
        let arraySut1: [UInt8] = .init(integer: 0x12345678)
        let arraySut2: [UInt16] = .init(integer: 0x12345678)
        let arraySut3: [UInt32] = .init(integer: 0x12345678)
        XCTAssertEqual(arraySut1, [0x12, 0x34, 0x56, 0x78])
        XCTAssertEqual(arraySut2, [0x1234, 0x5678])
        XCTAssertEqual(arraySut3, [0x12345678])
    }
}
