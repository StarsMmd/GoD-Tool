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
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint16),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .uint32)
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint8),
                .init(name: "test2", type: .int32),
                .init(name: "test3", type: .uint16),
                .init(name: "test4", type: .uint8),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .enumeration(weekEnum))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big)
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
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint16),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .uint32)
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint8),
                .init(name: "test2", type: .int32),
                .init(name: "test3", type: .uint16),
                .init(name: "test4", type: .uint8),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .enumeration(weekEnum))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big)
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
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint16),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .uint32)
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint8),
                .init(name: "test2", type: .int32),
                .init(name: "test3", type: .uint16),
                .init(name: "test4", type: .uint8),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .enumeration(weekEnum))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big)
        )

        XCTAssertEqual(try sut.test1, 0)
        XCTAssertEqual(try sut.test2, 0x04050607)
        XCTAssertEqual(try sut.test3, 0x0809)
        XCTAssertEqual(try sut.test4, 10)
        XCTAssertEqual(try sut.test6, 24)

        XCTAssertEqual(try sut.test5, GoDData(byteStream: [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], byteOrder: .big))
        let sut2: StructData? = sut.test5
        XCTAssertEqual(sut2?.test1, 0x0c0d)
        XCTAssertEqual(sut2?.test2, [0x0e0f, 0x1011, 0x1213] as [UInt16])
        XCTAssertEqual(sut2?.test3, 0x14151617)
        XCTAssertEqual(sut2?.test3, [20, 21, 22, 23] as [UInt8])
    }

    func testSet() {
        let subdef = StructDefinition(
            name: "Test1",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint16),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .uint32)
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint8),
                .init(name: "test2", type: .int32),
                .init(name: "test3", type: .uint16),
                .init(name: "test4", type: .uint8),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .enumeration(weekEnum))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big)
        )

        sut.set("test1", to: GoDData(length: 1))
        sut.set("test2", to: GoDData(length: 4))
        sut.set("test3", to: GoDData(length: 2))
        sut.set("test4", to: GoDData(length: 1))
        sut.set("test5", to: GoDData(length: 12))
        sut.set("test6", to: GoDData(length: 1))

        func checkNull(_ key: String) -> Bool {
            let data: GoDData = sut.get(key)!
            return data.isNull
        }
        XCTAssertTrue(checkNull("test1"))
        XCTAssertTrue(checkNull("test2"))
        XCTAssertTrue(checkNull("test3"))
        XCTAssertTrue(checkNull("test4"))
        XCTAssertTrue(checkNull("test5"))
        XCTAssertTrue(checkNull("test6"))

        XCTAssertTrue(checkNull("test5.test1"))
        XCTAssertTrue(checkNull("test5.test2"))
        XCTAssertTrue(checkNull("test5.test3"))

        sut.set("test5.test1", to: [UInt8]([1,2]))
        sut.set("test5.test2", to: [UInt8]([3,4,5,6,7,8]))
        sut.set("test5.test3", to: [UInt8]([9,10,11,12]))

        XCTAssertEqual(sut.get("test5.test1"), 0x102)
        XCTAssertEqual(sut.get("test5.test2"), [UInt16]([0x304,0x506,0x708]))
        XCTAssertEqual(sut.get("test5.test3"), 0x90a0b0c)
    }

    func testDynamicMemberSet() {
        let subdef = StructDefinition(
            name: "Test1",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint16),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .uint32)
            ]
        )
        let def = StructDefinition(
            name: "Test2",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint8),
                .init(name: "test2", type: .int32),
                .init(name: "test3", type: .uint16),
                .init(name: "test4", type: .uint8),
                .init(name: "test5", type: .subStruct(subdef)),
                .init(name: "test6", type: .enumeration(weekEnum))
            ]
        )
        let rawBytes: [UInt8] = Array(0 ..< UInt8(def.length))
        let sut = StructData(
            definition: def,
            data: GoDData(byteStream: rawBytes, byteOrder: .big)
        )

        sut.test1 = GoDData(length: 1)
        sut.test2 = GoDData(length: 4)
        sut.test3 = GoDData(length: 2)
        sut.test4 = GoDData(length: 1)
        sut.test5 = GoDData(length: 12)
        sut.test6 = GoDData(length: 1)

        func checkNull(_ key: String) -> Bool {
            let data: GoDData = sut.get(key)!
            return data.isNull
        }
        XCTAssertTrue(checkNull("test1"))
        XCTAssertTrue(checkNull("test2"))
        XCTAssertTrue(checkNull("test3"))
        XCTAssertTrue(checkNull("test4"))
        XCTAssertTrue(checkNull("test5"))
        XCTAssertTrue(checkNull("test6"))
    }

    func testGetValues() {
        let data = Array<UInt8>(1...8) + [0x3f, 0x80, 0x00, 0x00]
        let structData = StructData(
            definition: StructDefinition(
                name: "Test",
                wordSize: 4,
                alignmentStyle: .cStyle,
                properties: [
                    .init(
                        name: "test1",
                        type: .uint8
                    ),
                    .init(
                        name: "test2",
                        type: .uint16
                    ),
                    .init(
                        name: "test3",
                        type: .uint32
                    ),
                    .init(
                        name: "test4",
                        type: .float
                    )
                ]),
            data: GoDData(byteStream: data, byteOrder: .big)
        )

        XCTAssertEqual(structData.get("test1"), UInt8(0x01))
        XCTAssertEqual(structData.get("test2"), UInt16(0x0304))
        XCTAssertEqual(structData.get("test3"), UInt32(0x05060708))
        XCTAssertEqual(structData.get("test4"), Float(1.0))

        let structData2 = StructData(
            definition: StructDefinition(
                name: "Test",
                wordSize: 4,
                alignmentStyle: .cStyle,
                properties: [
                    .init(
                        name: "test1",
                        type: .uint8
                    ),
                    .init(
                        name: "test2",
                        type: .uint16
                    ),
                    .init(
                        name: "test3",
                        type: .uint32
                    ),
                    .init(
                        name: "test4",
                        type: .float
                    )
                ]),
            data: GoDData(byteStream: data, byteOrder: .little)
        )

        XCTAssertEqual(structData2.get("test1"), UInt8(0x01))
        XCTAssertEqual(structData2.get("test2"), UInt16(0x0403))
        XCTAssertEqual(structData2.get("test3"), UInt32(0x08070605))
    }

    func testSetValues() {
        let data = Array<UInt8>(1...8) + [0x3f, 0x80, 0x00, 0x00]
        let structData = StructData(
            definition: StructDefinition(
                name: "Test",
                wordSize: 4,
                alignmentStyle: .cStyle,
                properties: [
                    .init(
                        name: "test1",
                        type: .int8
                    ),
                    .init(
                        name: "test2",
                        type: .int16
                    ),
                    .init(
                        name: "test3",
                        type: .int32
                    ),
                    .init(
                        name: "test4",
                        type: .float
                    )
                ]),
            data: GoDData(byteStream: data, byteOrder: .big)
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
    
    func testEnums() {
        let data = GoDData(byteOrder: .big)
        data.append(Array<UInt8>([0,10,6,0xFF]).rawData)
        data.append(Array<Int8>([0,-1,-128,0x7F]).rawData)
        
        let structData = StructData(
            definition: StructDefinition(
                name: "Test",
                wordSize: 4,
                alignmentStyle: .cStyle,
                properties: [
                    .init(
                        name: "test81",
                        type: .enumeration(weekEnum)
                    ),
                    .init(
                        name: "test82",
                        type: .enumeration(weekEnum)
                    ),
                    .init(
                        name: "test83",
                        type: .enumeration(weekEnum)
                    ),
                    .init(
                        name: "test84",
                        type: .enumeration(weekEnum)
                    ),
                    .init(
                        name: "test85",
                        type: .enumeration(moonPhasesEnum)
                    ),
                    .init(
                        name: "test86",
                        type: .enumeration(moonPhasesEnum)
                    ),
                    .init(
                        name: "test87",
                        type: .enumeration(moonPhasesEnum)
                    ),
                    .init(
                        name: "test88",
                        type: .enumeration(moonPhasesEnum)
                    )
                ]),
            data: data
        )
        
        XCTAssertEqual(structData.get("test81"), try weekEnum.monday)
        let value82: Enum.Case? = structData.get("test82")
        XCTAssertNil(value82)
        XCTAssertEqual(structData.get("test83"), try weekEnum.sunday)
        let value84: Enum.Case? = structData.get("test84")
        XCTAssertNil(value84)
        
        XCTAssertEqual(structData.get("test85"), try moonPhasesEnum.new)
        XCTAssertEqual(structData.get("test86"), try moonPhasesEnum.waningGibbous)
        let value87: Enum.Case? = structData.get("test87")
        XCTAssertNil(value87)
        let value88: Enum.Case? = structData.get("test88")
        XCTAssertNil(value88)
        
    }
}
