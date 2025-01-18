//
//  GoDDataTests.swift
//  
//
//  Created by Stars Momodu on 29/05/2022.
//

import XCTest
@testable import GoDFoundation

class GoDDataTests: XCTestCase {
    
    func testLength() {
        let data = GoDData(byteStream: [0x50, 0x4F, 0x4B, 0x65, 0x4D, 0x4F, 0x4E, 0x20, 0x58, 0x44, 0x00, 0x00])
        XCTAssertEqual(data.length, 12)
        let data2 = GoDData(length: 100)
        XCTAssertEqual(data2.length, 100)
    }
    
    func testEmptyLength() {
        let data = GoDData(byteStream: [UInt8]())
        XCTAssertEqual(data.length, 0)
        let data2 = GoDData(length: 0)
        XCTAssertEqual(data2.length, 0)
        let data3 = GoDData()
        XCTAssertEqual(data3.length, 0)
    }
    
    func testString() {
        let data = GoDData(byteStream: [0x50, 0x4F, 0x4B, 0x65, 0x4D, 0x4F, 0x4E, 0x20, 0x58, 0x44])
        XCTAssertEqual(data.string(format: .utf8), "POKeMON XD")
        let data2 = GoDData()
        XCTAssertEqual(data2.string(format: .unicode_little), "")
        let data3 = GoDData(string: "", format: .unicode_little)
        XCTAssertEqual(data3.string(format: .unicode_little), "")
        let data4 = GoDData(string: "simple", format: .unicode_little)
        XCTAssertEqual(data4.string(format: .unicode_little), "simple")
        let data5 = GoDData(string: "Ab1-+[{ ;\"`~!@", format: .unicode_little)
        XCTAssertEqual(data5.string(format: .unicode_little), "Ab1-+[{ ;\"`~!@")
        let data6 = GoDData(byteStream: [0x00, 0x4E, 0x00, 0x49, 0x00, 0x44, 0x00, 0x4F, 0x00, 0x52, 0x00, 0x41, 0x00, 0x4E, 0x26, 0x40, 0x00, 0x00])
        XCTAssertEqual(data6.string(format: .gs), "NIDORAN♀")
    }
    
    func testRawBytes() {
        let data = GoDData(byteStream: [0x50, 0x4F, 0x4B, 0x65, 0x4D, 0x4F, 0x4E, 0x20, 0x58, 0x44, 0x00, 0x00])
        XCTAssertEqual(data.rawBytes, [0x50, 0x4F, 0x4B, 0x65, 0x4D, 0x4F, 0x4E, 0x20, 0x58, 0x44, 0x00, 0x00])
        XCTAssertEqual(data.byteStream, [0x50, 0x4F, 0x4B, 0x65, 0x4D, 0x4F, 0x4E, 0x20, 0x58, 0x44, 0x00, 0x00])
    }
    
    func testStringLiteral() {
        let data: GoDData = GoDData(byteStream: [0x00, 0x50, 0x00, 0x4F, 0x00, 0x4B, 0x00, 0x65, 0x00, 0x4D, 0x00, 0x4F, 0x00, 0x4E, 0x00, 0x20, 0x00, 0x58, 0x00, 0x44])
        XCTAssertEqual(data.string(format: .gs), "POKeMON XD")
    }
    
    func testCopy() {
        let original: GoDData = "test data"
        let copy = original.copy
        XCTAssertEqual(original.byteStream, copy.byteStream)
    }
    
    func testNull() {
        let data = GoDData(byteStream: [0])
        XCTAssertTrue(data.isNull)
        let data2 = GoDData(byteStream: [0,0])
        XCTAssertTrue(data2.isNull)
        let data3 = GoDData(byteStream: [0,0,0,0,0,0])
        XCTAssertTrue(data3.isNull)
        let data4 = GoDData()
        XCTAssertTrue(data4.isNull)
        let data5 = GoDData(length: 100)
        XCTAssertTrue(data5.isNull)
    }
    
    func testSubscript() {
        let data = GoDData(byteStream: [0,1,2,3,4,5])
        XCTAssertEqual(data[1], 1)
        XCTAssertEqual(data[4], 4)
        XCTAssertEqual(data[safe: 5], 5)
        XCTAssertEqual(data[safe: 6], nil)
        
        data[2] = 7
        XCTAssertEqual(data[1], 1)
        XCTAssertEqual(data[4], 4)
        XCTAssertEqual(data[2], 7)
        XCTAssertEqual(data[safe: 5], 5)
        XCTAssertEqual(data[safe: 6], nil)
    }
    
    func testByteOrder() {
        let data = GoDData(byteStream: [1, 2, 3, 4], byteOrder: .big)
        data.switchByteOrder(boundary: 4)
        XCTAssertEqual(data.rawBytes, [4, 3, 2, 1])
        let data2 = GoDData(byteStream: [1, 2], byteOrder: .big)
        data2.switchByteOrder(boundary: 4)
        XCTAssertEqual(data2.rawBytes, [2, 1])
        let data3 = GoDData(byteStream: [1], byteOrder: .big)
        data3.switchByteOrder(boundary: 4)
        XCTAssertEqual(data3.rawBytes, [1])
        let data4 = GoDData(byteStream: [1, 2, 3, 4, 5, 6, 7, 8], byteOrder: .big)
        data4.switchByteOrder(boundary: 4)
        XCTAssertEqual(data4.rawBytes, [4, 3, 2, 1, 8, 7, 6, 5])

        let dataB = GoDData(byteStream: [1, 2, 3, 4], byteOrder: .little)
        dataB.switchByteOrder(boundary: 2)
        XCTAssertEqual(dataB.rawBytes, [2, 1, 4, 3])
        let dataB2 = GoDData(byteStream: [1, 2], byteOrder: .little)
        dataB2.switchByteOrder(boundary: 2)
        XCTAssertEqual(dataB2.rawBytes, [2, 1])
        let dataB3 = GoDData(byteStream: [1], byteOrder: .little)
        dataB3.switchByteOrder(boundary: 2)
        XCTAssertEqual(dataB3.rawBytes, [1])
        let dataB4 = GoDData(byteStream: [1, 2, 3, 4, 5, 6, 7, 8], byteOrder: .little)
        dataB4.switchByteOrder(boundary: 2)
        XCTAssertEqual(dataB4.rawBytes, [2, 1, 4, 3, 6, 5, 8, 7])

        let dataC = GoDData(byteStream: [1, 2, 3, 4], byteOrder: .unspecified)
        dataC.switchByteOrder(boundary: 4)
        XCTAssertEqual(dataC.rawBytes, [1, 2, 3, 4])
    }
    
    func testRead() {
        let data = GoDData(byteStream: [0xAB, 0xCD, 0xEF, 0x12])
        let value1 = data.read(atAddress: 0, length: 4)
        let value2 = data.read(atAddress: 2, length: 2)
        let value3 = data.read(atAddress: 1, length: 2)
        let value4 = data.read(atAddress: 1, length: 0)
        let value5 = data.read(atAddress: 1, length: 3)
        let value6 = data.read(atAddress: 1, length: 1)
        XCTAssertEqual(value1?.rawBytes,[0xAB, 0xCD, 0xEF, 0x12])
        XCTAssertEqual(value2?.rawBytes,[0xEF, 0x12])
        XCTAssertEqual(value3?.rawBytes,[0xCD, 0xEF])
        XCTAssertEqual(value4?.rawBytes,[])
        XCTAssertEqual(value5?.rawBytes,[0xCD, 0xEF, 0x12])
        XCTAssertEqual(value6?.rawBytes,[0xCD])
        
        let null = data.read(atAddress: 0, length: 8)
        XCTAssertEqual(null?.rawBytes, nil)
        let null2 = data.read(atAddress: 10, length: 1)
        XCTAssertEqual(null2?.rawBytes, nil)
    }
    
    func testReadStringUTF8() {
        let data: GoDData = GoDData(string: "test data", format: .utf8)
        let test = data.readString(atAddress: 0, format: .utf8)
        let tes = data.readString(atAddress: 0, format: .utf8, maxCharacters: 3)
        let null = data.readString(atAddress: 9, format: .utf8)
        let null2 = data.readString(atAddress: 9, format: .utf8, maxCharacters: 2)
        XCTAssertEqual(test, "test data")
        XCTAssertEqual(tes, "tes")
        XCTAssertEqual(null, nil)
        XCTAssertEqual(null2, nil)
        
        data.append(UInt8(0))
        data.appendString("second string", format: .utf8)
        let secondString = data.readString(atAddress: 10, format: .utf8)
        let second = data.readString(atAddress: 10, format: .utf8, maxCharacters: 6)
        let testData = data.readString(atAddress: 0, format: .utf8)
        XCTAssertEqual(secondString, "second string")
        XCTAssertEqual(second, "second")
        XCTAssertEqual(testData, "test data")
    }
    
    func testReadStringUTF8Literal() {
        let data: GoDData = "test data"
        let test = data.readString(atAddress: 0, format: .utf8)
        let tes = data.readString(atAddress: 0, format: .utf8, maxCharacters: 3)
        let null = data.readString(atAddress: 9, format: .utf8)
        let null2 = data.readString(atAddress: 9, format: .utf8, maxCharacters: 2)
        XCTAssertEqual(test, "test data")
        XCTAssertEqual(tes, "tes")
        XCTAssertEqual(null, nil)
        XCTAssertEqual(null2, nil)
        
        data.append(UInt8(0))
        data.append("second string")
        let secondString = data.readString(atAddress: 10, format: .utf8)
        let second = data.readString(atAddress: 10, format: .utf8, maxCharacters: 6)
        let testData = data.readString(atAddress: 0, format: .utf8)
        XCTAssertEqual(secondString, "second string")
        XCTAssertEqual(second, "second")
        XCTAssertEqual(testData, "test data")
    }
    
    func testReadStringUTF16() {
        let data: GoDData = GoDData(string: "test data", format: .utf16_little)
        let test = data.readString(atAddress: 0, format: .utf16_little)
        let tes = data.readString(atAddress: 0, format: .utf16_little, maxCharacters: 3)
        let null = data.readString(atAddress: 20, format: .utf16_little)
        let null2 = data.readString(atAddress: 20, format: .utf16_little, maxCharacters: 2)
        XCTAssertEqual(test, "test data")
        XCTAssertEqual(tes, "tes")
        XCTAssertEqual(null, nil)
        XCTAssertEqual(null2, nil)
        Swift.print(data.rawBytes)
        
        data.append(UInt16(0))
        data.appendString("second string", format: .utf16_little)
        let secondString = data.readString(atAddress: 22, format: .utf16_little)
        let testData = data.readString(atAddress: 0, format: .utf16_little)
        XCTAssertEqual(secondString, "second string")
        XCTAssertEqual(testData, "test data")
    }
    
    func testReadStringUnicode() {
        let data: GoDData = GoDData(string: "test data", format: .unicode_little)
        let test = data.readString(atAddress: 0, format: .unicode_little)
        let tes = data.readString(atAddress: 0, format: .unicode_little, maxCharacters: 3)
        let null = data.readString(atAddress: 20, format: .unicode_little)
        let null2 = data.readString(atAddress: 20, format: .unicode_little, maxCharacters: 2)
        XCTAssertEqual(test, "test data")
        XCTAssertEqual(tes, "tes")
        XCTAssertEqual(null, nil)
        XCTAssertEqual(null2, nil)
        
        data.append(UInt16(0))
        data.appendString("second string", format: .unicode_little)
        let secondString = data.readString(atAddress: 22, format: .unicode_little)
        let testData = data.readString(atAddress: 0, format: .unicode_little)
        XCTAssertEqual(secondString, "second string")
        XCTAssertEqual(testData, "test data")
    }
    
    func testAppend() {
        let data: GoDData = "test "
        data.append("data")
        XCTAssertEqual(data.string(format: .utf8), "test data")
        
        let data2: GoDData = ""
        data2.append("datum")
        XCTAssertEqual(data2.string(format: .utf8), "datum")
        
        let data3: GoDData = "test"
        data3.append("")
        XCTAssertEqual(data3.string(format: .utf8), "test")
    }
    
    func testInsert() {
        let data: GoDData = "testdata"
        data.insert(" ", atOffset: 4)
        XCTAssertEqual(data.string(format: .utf8), "test data")
        
        let data2: GoDData = ""
        data2.insert("datum", atOffset: 0)
        XCTAssertEqual(data2.string(format: .utf8), "datum")
        
        let data3: GoDData = "test"
        data3.insert("", atOffset: 2)
        XCTAssertEqual(data3.string(format: .utf8), "test")
    }
    
    func testDelete() {
        let data: GoDData = "test data"
        data.delete(start: 4, count: 1)
        XCTAssertEqual(data.string(format: .utf8), "testdata")
        data.delete(start: 1, count: 3)
        XCTAssertEqual(data.string(format: .utf8), "tdata")
    }
    
    func testSearch() {
        let data: GoDData = "let's test this string @ now test"
        let at = data.search(for: "@")
        let test = data.search(for: "test")
        let test1 = data.search(for: "test", fromOffset: 7)
        let test2 = data.search(for: "test", fromOffset: 6)
        let null = data.search(for: "hello")
        let null2 = data.search(for: "hey", fromOffset: 0)
        let null3 = data.search(for: "this", fromOffset: 20)
        XCTAssertEqual(at, [23])
        XCTAssertEqual(test, [6, 29])
        XCTAssertEqual(test1, 29)
        XCTAssertEqual(test2, 6)
        XCTAssertEqual(null, [])
        XCTAssertNil(null2)
        XCTAssertNil(null3)
    }
    
    func testDescription() {
        let data: GoDData = "Pokemon @123"
        XCTAssertEqual(data.description, "Pokemon @123")
    }
    
    func testWrite() {
        let data: GoDData = "Jinx"
        data.write("y", atAddress: 1)
        XCTAssertEqual(data.string(format: .utf8), "Jynx")
        
        data.write("lion", atAddress: 0)
        XCTAssertEqual(data.string(format: .utf8), "lion")
        
        data.write("mes", atAddress: 2)
        XCTAssertEqual(data.string(format: .utf8), "limes")
    }
    
    func testReadInt8() {
        let data = GoDData(byteStream: [0x01,0x02,0x03,0x04])
        let sut1: Int8? = data.readPrimtive(atAddress: 0)
        let sut2: Int8? = data.readPrimtive(atAddress: 0)
        let sut3: UInt8? = data.readPrimtive(atAddress: 0)
        let sut4: UInt8? = data.readPrimtive(atAddress: 0)
        XCTAssertEqual(sut1, 0x01)
        XCTAssertEqual(sut2, 0x01)
        XCTAssertEqual(sut3, 0x01)
        XCTAssertEqual(sut4, 0x01)
    }
    
    func testReadInt16() {
        let data = GoDData(byteStream: [0x01,0x02,0x03,0x04], byteOrder: .big)
        let data2 = GoDData(byteStream: [0x01,0x02,0x03,0x04], byteOrder: .little)
        let sut1: Int16? = data.readPrimtive(atAddress: 0)
        let sut2: Int16? = data2.readPrimtive(atAddress: 0)
        let sut3: UInt16? = data.readPrimtive(atAddress: 0)
        let sut4: UInt16? = data2.readPrimtive(atAddress: 0)
        XCTAssertEqual(sut1, 0x0102)
        XCTAssertEqual(sut2, 0x0201)
        XCTAssertEqual(sut3, 0x0102)
        XCTAssertEqual(sut4, 0x0201)
    }
    
    func testReadInt32() {
        let data = GoDData(byteStream: [0x01,0x02,0x03,0x04], byteOrder: .big)
        let data2 = GoDData(byteStream: [0x01,0x02,0x03,0x04], byteOrder: .little)
        let sut1: Int32? = data.readPrimtive(atAddress: 0)
        let sut2: Int32? = data2.readPrimtive(atAddress: 0)
        let sut3: UInt32? = data.readPrimtive(atAddress: 0)
        let sut4: UInt32? = data2.readPrimtive(atAddress: 0)
        XCTAssertEqual(sut1, 0x01020304)
        XCTAssertEqual(sut2, 0x04030201)
        XCTAssertEqual(sut3, 0x01020304)
        XCTAssertEqual(sut4, 0x04030201)
    }
    
    func testReadFloat() {
        let data1 = GoDData(byteStream: [0x3F,0x80,0x00,0x00], byteOrder: .big)
        let sut1: Float? = data1.readPrimtive(atAddress: 0)
        XCTAssertEqual(sut1, 1.0)
        
        let data2 = GoDData(byteStream: [0x00,0x00,0x80,0x3F], byteOrder: .little)
        let sut2: Float? = data2.readPrimtive(atAddress: 0)
        XCTAssertEqual(sut2, 1.0)
    }
}
