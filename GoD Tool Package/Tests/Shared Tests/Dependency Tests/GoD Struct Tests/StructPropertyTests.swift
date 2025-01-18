//
//  StructPropertyTests.swift
//  
//
//  Created by Stars Momodu on 23/07/2022.
//

import Foundation
@testable import Structs
import XCTest

class StructPropertyTests: XCTestCase {

    func testPrimitivesLength() {
        let sut1 = StructProperty.primitive(.integer(.uint8))
        let sut2 = StructProperty.primitive(.integer(.int8))
        let sut3 = StructProperty.primitive(.integer(.uint16))
        let sut4 = StructProperty.primitive(.integer(.int16))
        let sut5 = StructProperty.primitive(.integer(.uint32))
        let sut6 = StructProperty.primitive(.integer(.int32))
        let sut7 = StructProperty.primitive(.integer(.uint64))
        let sut8 = StructProperty.primitive(.integer(.int64))
        let sut11 = StructProperty.primitive(.float)
        let sut12 = StructProperty.primitive(.double)
        let sut13 = StructProperty.primitive(.character(.utf8))
        let sut14 = StructProperty.primitive(.character(.utf16_big))
        let sut15 = StructProperty.primitive(.character(.utf16_little))
        let sut16 = StructProperty.primitive(.character(.ascii_big))
        let sut17 = StructProperty.primitive(.character(.ascii_little))
        let sut18 = StructProperty.primitive(.character(.unicode_big))
        let sut19 = StructProperty.primitive(.character(.unicode_little))
        let sut20 = StructProperty.primitive(.character(.gs))
        let sut21 = StructProperty.primitive(.character(.gsColo))
        let sut22 = StructProperty.primitive(.character(.gsXD))
        let sut23 = StructProperty.primitive(.character(.gsPBR))

        XCTAssertEqual(sut1.length, 1)
        XCTAssertEqual(sut2.length, 1)
        XCTAssertEqual(sut3.length, 2)
        XCTAssertEqual(sut4.length, 2)
        XCTAssertEqual(sut5.length, 4)
        XCTAssertEqual(sut6.length, 4)
        XCTAssertEqual(sut7.length, 8)
        XCTAssertEqual(sut8.length, 8)
        XCTAssertEqual(sut11.length, 4)
        XCTAssertEqual(sut12.length, 8)
        XCTAssertEqual(sut13.length, 1)
        XCTAssertEqual(sut14.length, 2)
        XCTAssertEqual(sut15.length, 2)
        XCTAssertEqual(sut16.length, 2)
        XCTAssertEqual(sut17.length, 2)
        XCTAssertEqual(sut18.length, 2)
        XCTAssertEqual(sut19.length, 2)
        XCTAssertEqual(sut20.length, 2)
        XCTAssertEqual(sut21.length, 2)
        XCTAssertEqual(sut22.length, 2)
        XCTAssertEqual(sut23.length, 2)
    }

    func testArrayLength() {
        let testProperties: [StructProperty] = [
            .primitive(.float), .primitive(.double), .primitive(.integer(.uint16))
        ]
        let testArrays: [StructProperty] = testProperties.map { .array($0, count: 3) }

        (testProperties + testArrays).forEach { prop in
            let array0 = StructProperty.array(prop, count: 0)
            XCTAssertEqual(array0.length, 0)
            let array1 = StructProperty.array(prop, count: 1)
            XCTAssertEqual(array1.length, prop.length)
            let array2 = StructProperty.array(prop, count: 2)
            XCTAssertEqual(array2.length, prop.length * 2)
            let array100 = StructProperty.array(prop, count: 100)
            XCTAssertEqual(array100.length, prop.length * 100)
        }
    }

    func testSubStructLength() {
        let structDef = StructDefinition(
            name: "Test",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.integer(.uint8))),
                .init(name: "test2", type: .primitive(.integer(.uint16))),
                .init(name: "test3", type: .primitive(.integer(.int32)))
            ]
        )
        let sut = StructProperty.subStruct(structDef)

        XCTAssertEqual(sut.length, structDef.length)
    }

    func testSubStructArrayLength() {
        let structDef = StructDefinition(
            name: "Test",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.integer(.uint8))),
                .init(name: "test2", type: .primitive(.integer(.uint16))),
                .init(name: "test3", type: .primitive(.integer(.int32)))
            ]
        )
        let sut = StructProperty.array(.subStruct(structDef), count: 3)

        XCTAssertEqual(sut.length, structDef.length * 3)
    }
}
