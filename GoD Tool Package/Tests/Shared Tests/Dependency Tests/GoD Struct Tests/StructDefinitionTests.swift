//
//  StructDefinitionTests.swift
//  
//
//  Created by Stars Momodu on 23/07/2022.
//

import Foundation
@testable import Structs
import XCTest

class StructDefinitionTests: XCTestCase {

    func testInit() {
        let sut = StructDefinition(
            name: "Test",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint8)),
                .init(name: "test2", type: .primitive(.int16))
            ]
        )

        XCTAssertEqual(sut.name, "Test")
        XCTAssertEqual(sut.properties[0].name, "test1")
        XCTAssertEqual(sut.properties[0].type, .primitive(.uint8))
        XCTAssertEqual(sut.properties[1].name, "test2")
        XCTAssertEqual(sut.properties[1].type, .primitive(.int16))
        XCTAssertEqual(sut.alignmentStyle, .cStyle)
        XCTAssertEqual(sut.length, 4)
        XCTAssertEqual(sut.longestAlignment, 2)
        XCTAssertEqual(sut.offset(for: "test2"), 2)
        XCTAssertEqual(sut.property(for: "test1"), .primitive(.uint8))
    }

    func testLength1() {
        let sut = StructDefinition(
            name: "Test",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint8)),
                .init(name: "test2", type: .primitive(.int32)),
                .init(name: "test3", type: .primitive(.uint16)),
                .init(name: "test4", type: .primitive(.int8)),
            ]
        )

        XCTAssertEqual(sut.length, 12)
    }

    func testLength2() {
        let sut = StructDefinition(
            name: "Test",
            alignmentStyle: .none,
            properties: [
                .init(name: "test1", type: .primitive(.uint8)),
                .init(name: "test2", type: .primitive(.int32)),
                .init(name: "test3", type: .primitive(.uint16)),
                .init(name: "test4", type: .primitive(.int8)),
            ]
        )

        XCTAssertEqual(sut.length, 8)
    }

    func testLength3() {
        let sut = StructDefinition(
            name: "Test",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint8)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.uint32))
            ]
        )

        XCTAssertEqual(sut.length, 12)
    }

    func testLength4() {
        let subsut = StructDefinition(
            name: "Test1",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint16)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.uint32))
            ]
        )

        let sut = StructDefinition(
                    name: "Test2",
                    alignmentStyle: .cStyle,
                    properties: [
                        .init(name: "test1", type: .primitive(.uint8)),
                        .init(name: "test2", type: .primitive(.int32)),
                        .init(name: "test3", type: .primitive(.uint16)),
                        .init(name: "test4", type: .primitive(.uint8)),
                        .init(name: "test5", type: .subStruct(subsut)),
                        .init(name: "test6", type: .abstraction(.primitive(.int8), typeName: "test"))
                    ]
                )

        XCTAssertEqual(subsut.length, 12)
        XCTAssertEqual(sut.length, 28)
    }

    func testLength5() {
        let subsut = StructDefinition(
            name: "Test1",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint16)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.float)),
                .init(name: "test4", type: .primitive(.int8))
            ]
        )

        let sut = StructDefinition(
                    name: "Test2",
                    alignmentStyle: .cStyle,
                    properties: [
                        .init(name: "test1", type: .primitive(.uint8)),
                        .init(name: "test2", type: .array(.subStruct(subsut), count: 5))
                    ]
                )

        XCTAssertEqual(subsut.length, 16)
        XCTAssertEqual(sut.length, 84)
    }

    func testPropertyOffset() {
        let subsut = StructDefinition(
            name: "Test1",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint16)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.float)),
                .init(name: "test4", type: .primitive(.int8))
            ]
        )

        let sut = StructDefinition(
                    name: "Test2",
                    alignmentStyle: .cStyle,
                    properties: [
                        .init(name: "test1", type: .primitive(.uint8)),
                        .init(name: "test2", type: .subStruct(subsut))
                    ]
                )

        XCTAssertEqual(subsut.length, 16)
        XCTAssertEqual(sut.length, 20)

        XCTAssertEqual(sut.offset(for: "test1"), 0)
        XCTAssertEqual(sut.offset(for: "test2"), 4)
        XCTAssertEqual(sut.offset(for: "test2.test1"), 4)
        XCTAssertEqual(sut.offset(for: "test2.test2"), 6)
        XCTAssertEqual(sut.offset(for: "test2.test3"), 12)
        XCTAssertEqual(sut.offset(for: "test2.test4"), 16)
    }

    func testProperties() {
        let subsut = StructDefinition(
            name: "Test1",
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .primitive(.uint16)),
                .init(name: "test2", type: .array(.primitive(.uint16), count: 3)),
                .init(name: "test3", type: .primitive(.float)),
                .init(name: "test4", type: .primitive(.int8))
            ]
        )

        let sut = StructDefinition(
                    name: "Test2",
                    alignmentStyle: .cStyle,
                    properties: [
                        .init(name: "test1", type: .primitive(.uint8)),
                        .init(name: "test2", type: .subStruct(subsut))
                    ]
                )

        XCTAssertEqual(subsut.length, 16)
        XCTAssertEqual(sut.length, 20)

        XCTAssertEqual(sut.property(for: "test1"), .primitive(.uint8))
        XCTAssertEqual(sut.property(for: "test2"), .subStruct(subsut))
        XCTAssertEqual(sut.property(for: "test2.test1"), .primitive(.uint16))
        XCTAssertEqual(sut.property(for: "test2.test2"), .array(.primitive(.uint16), count: 3))
        XCTAssertEqual(sut.property(for: "test2.test3"), .primitive(.float))
        XCTAssertEqual(sut.property(for: "test2.test4"), .primitive(.int8))
    }
}
