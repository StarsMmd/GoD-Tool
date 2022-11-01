//
//  StructDataTests.swift
//  
//
//  Created by Stars Momodu on 24/07/2022.
//

import Foundation
import GoDFoundation
@testable import Structs
import XCTest

class StructDataTests: XCTestCase {

    func testInit() {
        let subdef = StructDefinition(
            name: "Test1",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint16)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.uint32))
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint8)),
                .init(name: "test2", type: .primitive(.int32)),
                .init(name: "test3", type: .primitive(.uint16)),
                .init(name: "test4", type: .primitive(.uint8)),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .abstraction(.primitive(.int8), typeName: "test"))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big),
            wordSize: 4
        )

        XCTAssertEqual(sut.name, def.name)
        XCTAssertEqual(sut.properties, def.properties)
        XCTAssertEqual(sut.data.length, Int(def.length))
        XCTAssertEqual(sut.wordSize, 4)
        XCTAssertEqual(sut.data.rawBytes, rawBytes)
    }

    func testGet() {
        let subdef = StructDefinition(
            name: "Test1",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint16)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.uint32))
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint8)),
                .init(name: "test2", type: .primitive(.int32)),
                .init(name: "test3", type: .primitive(.uint16)),
                .init(name: "test4", type: .primitive(.uint8)),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .abstraction(.primitive(.int8), typeName: "test"))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big),
            wordSize: 4
        )

        XCTAssertEqual(sut.get("test1"), 0)
        XCTAssertEqual(sut.get("test2"), 0x04050607)
        XCTAssertEqual(sut.get("test3"), 0x0809)
        XCTAssertEqual(sut.get("test4"), 10)
        XCTAssertEqual(sut.get("test6"), 24)

        XCTAssertEqual(sut.get("test5"), GoDData(byteStream: [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], byteOrder: .big))
        XCTAssertEqual(sut.get("test5.test1"), 0x0c0d)
        XCTAssertEqual(sut.get("test5.test2"), [0x0e0f, 0x1011, 0x1213] as [UInt16])
        XCTAssertEqual(sut.get("test5.test3"), 0x14151617)
        XCTAssertEqual(sut.get("test5.test3"), [20, 21, 22, 23] as [UInt8])
    }

    func testDynamicMembertGet() {
        let subdef = StructDefinition(
            name: "Test1",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint16)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.uint32))
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint8)),
                .init(name: "test2", type: .primitive(.int32)),
                .init(name: "test3", type: .primitive(.uint16)),
                .init(name: "test4", type: .primitive(.uint8)),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .abstraction(.primitive(.int8), typeName: "test"))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big),
            wordSize: 4
        )

        XCTAssertEqual(sut.test1, 0)
        XCTAssertEqual(sut.test2, 0x04050607)
        XCTAssertEqual(sut.test3, 0x0809)
        XCTAssertEqual(sut.test4, 10)
        XCTAssertEqual(sut.test6, 24)

        XCTAssertEqual(sut.test5, GoDData(byteStream: [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], byteOrder: .big))
        let sut2: StructData? = sut.test5
        XCTAssertEqual(sut2?.test1, 0x0c0d)
        XCTAssertEqual(sut2?.test2, [0x0e0f, 0x1011, 0x1213] as [UInt16])
        XCTAssertEqual(sut2?.test3, 0x14151617)
        XCTAssertEqual(sut2?.test3, [20, 21, 22, 23] as [UInt8])
    }

    func testSet() {
        let subdef = StructDefinition(
            name: "Test1",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint16)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.uint32))
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint8)),
                .init(name: "test2", type: .primitive(.int32)),
                .init(name: "test3", type: .primitive(.uint16)),
                .init(name: "test4", type: .primitive(.uint8)),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .abstraction(.primitive(.int8), typeName: "test"))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big),
            wordSize: 4
        )

        sut.set("test1", to: GoDData(length: 1))
        sut.set("test2", to: GoDData(length: 4))
        sut.set("test3", to: GoDData(length: 2))
        sut.set("test4", to: GoDData(length: 1))
        sut.set("test5", to: GoDData(length: 12))
        sut.set("test6", to: GoDData(length: 1))

        XCTAssertTrue(sut.get("test1")!.isNull)
        XCTAssertTrue(sut.get("test2")!.isNull)
        XCTAssertTrue(sut.get("test3")!.isNull)
        XCTAssertTrue(sut.get("test4")!.isNull)
        XCTAssertTrue(sut.get("test5")!.isNull)
        XCTAssertTrue(sut.get("test6")!.isNull)

        XCTAssertTrue(sut.get("test5.test1")!.isNull)
        XCTAssertTrue(sut.get("test5.test2")!.isNull)
        XCTAssertTrue(sut.get("test5.test3")!.isNull)

        sut.set("test5.test1", to: GoDData([UInt8]([1,2])))
        sut.set("test5.test2", to: GoDData([UInt8]([3,4,5,6,7,8])))
        sut.set("test5.test3", to: GoDData([UInt8]([9,10,11,12])))

        XCTAssertEqual(sut.get("test5.test1"), [1, 2] as [UInt8])
        XCTAssertEqual(sut.get("test5.test2"), [3,4,5,6,7,8] as [UInt8])
        XCTAssertEqual(sut.get("test5.test3"), [9,10,11,12] as [UInt8])
    }

    func testDynamicMemberSet() {
        let subdef = StructDefinition(
            name: "Test1",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint16)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.uint32))
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint8)),
                .init(name: "test2", type: .primitive(.int32)),
                .init(name: "test3", type: .primitive(.uint16)),
                .init(name: "test4", type: .primitive(.uint8)),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .abstraction(.primitive(.int8), typeName: "test"))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big),
            wordSize: 4
        )

        sut.test1 = GoDData(length: 1)
        sut.test2 = GoDData(length: 4)
        sut.test3 = GoDData(length: 2)
        sut.test4 = GoDData(length: 1)
        sut.test5 = GoDData(length: 12)
        sut.test6 = GoDData(length: 1)

        XCTAssertTrue(sut.get("test1")!.isNull)
        XCTAssertTrue(sut.get("test2")!.isNull)
        XCTAssertTrue(sut.get("test3")!.isNull)
        XCTAssertTrue(sut.get("test4")!.isNull)
        XCTAssertTrue(sut.get("test5")!.isNull)
        XCTAssertTrue(sut.get("test6")!.isNull)
    }

    func testGetAbstraction() {
        let data = Array<UInt8>(1...8) + [0x3f, 0x80, 0x00, 0x00]
        let structData = StructData(
            definition: StructDefinition(
                name: "Test",
                alignmentStyle: .cStyle,
                properties: [
                    .init(
                        name: "test1",
                        type: .primitive(.uint8)
                    ),
                    .init(
                        name: "test2",
                        type: .primitive(.uint16)
                    ),
                    .init(
                        name: "test3",
                        type: .primitive(.uint32)
                    ),
                    .init(
                        name: "test4",
                        type: .primitive(.float)
                    )
                ]),
            data: GoDData(byteStream: data, byteOrder: .big),
            wordSize: 4
        )

        XCTAssertEqual(structData.get("test1"), UInt8(0x01))
        XCTAssertEqual(structData.get("test2"), UInt16(0x0304))
        XCTAssertEqual(structData.get("test3"), UInt32(0x05060708))
        XCTAssertEqual(structData.get("test4"), Float(1.0))

        let structData2 = StructData(
            definition: StructDefinition(
                name: "Test",
                alignmentStyle: .cStyle,
                properties: [
                    .init(
                        name: "test1",
                        type: .primitive(.uint8)
                    ),
                    .init(
                        name: "test2",
                        type: .primitive(.uint16)
                    ),
                    .init(
                        name: "test3",
                        type: .primitive(.uint32)
                    ),
                    .init(
                        name: "test4",
                        type: .primitive(.float)
                    )
                ]),
            data: GoDData(byteStream: data, byteOrder: .little),
            wordSize: 4
        )

        XCTAssertEqual(structData2.get("test1"), UInt8(0x01))
        XCTAssertEqual(structData2.get("test2"), UInt16(0x0403))
        XCTAssertEqual(structData2.get("test3"), UInt32(0x08070605))
    }

    func testSetAbstraction() {
        let data = Array<UInt8>(1...8) + [0x3f, 0x80, 0x00, 0x00]
        let structData = StructData(
            definition: StructDefinition(
                name: "Test",
                alignmentStyle: .cStyle,
                properties: [
                    .init(
                        name: "test1",
                        type: .primitive(.int8)
                    ),
                    .init(
                        name: "test2",
                        type: .primitive(.int16)
                    ),
                    .init(
                        name: "test3",
                        type: .primitive(.int32)
                    ),
                    .init(
                        name: "test4",
                        type: .primitive(.float)
                    )
                ]),
            data: GoDData(byteStream: data, byteOrder: .big),
            wordSize: 4
        )

        XCTAssertEqual(structData.get("test1"), Int8(0x01))
        XCTAssertEqual(structData.get("test2"), Int16(0x0304))
        XCTAssertEqual(structData.get("test3"), Int32(0x05060708))
        XCTAssertEqual(structData.get("test4"), Float(1.0))

        structData.set("test1", to: Int8(-1))
        structData.set("test2", to: Int16(-2))
        structData.set("test3", to: Int32(-3))
        structData.set("test4", to: Float(3.0))

        XCTAssertEqual(structData.get("test1"), Int8(-1))
        XCTAssertEqual(structData.get("test2"), Int16(-2))
        XCTAssertEqual(structData.get("test3"), Int32(-3))
        XCTAssertEqual(structData.get("test4"), Float(3.0))
    }
}
