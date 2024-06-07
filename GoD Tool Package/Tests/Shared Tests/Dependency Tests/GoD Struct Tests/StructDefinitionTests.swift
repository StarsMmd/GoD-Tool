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
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint8),
                .init(name: "test2", type: .int16)
            ]
        )

        XCTAssertEqual(sut.name, "Test")
        XCTAssertEqual(sut.properties[0].name, "test1")
        XCTAssertEqual(sut.properties[0].type, .uint8)
        XCTAssertEqual(sut.properties[1].name, "test2")
        XCTAssertEqual(sut.properties[1].type, .int16)
        XCTAssertEqual(sut.wordSize, 4)
        XCTAssertEqual(sut.alignmentStyle, .cStyle)
        XCTAssertEqual(sut.length, 4)
        XCTAssertEqual(sut.longestAlignment, 2)
        XCTAssertEqual(sut.offset(for: "test2"), 2)
        XCTAssertEqual(sut.property(for: "test1"), .uint8)
    }

    func testLength1() {
        let sut = StructDefinition(
            name: "Test",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint8),
                .init(name: "test2", type: .int32),
                .init(name: "test3", type: .uint16),
                .init(name: "test4", type: .int8),
            ]
        )

        XCTAssertEqual(sut.length, 12)
    }

    func testLength2() {
        let sut = StructDefinition(
            name: "Test",
            wordSize: 4,
            alignmentStyle: .none,
            properties: [
                .init(name: "test1", type: .uint8),
                .init(name: "test2", type: .int32),
                .init(name: "test3", type: .uint16),
                .init(name: "test4", type: .int8),
            ]
        )

        XCTAssertEqual(sut.length, 8)
    }

    func testLength3() {
        let sut = StructDefinition(
            name: "Test",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint8),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .uint32)
            ]
        )

        XCTAssertEqual(sut.length, 12)
    }

    func testLength4() {
        let subsut = StructDefinition(
            name: "Test1",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint16),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .uint32)
            ]
        )

        let sut = StructDefinition(
                    name: "Test2",
                    wordSize: 4,
                    alignmentStyle: .cStyle,
                    properties: [
                        .init(name: "test1", type: .uint8),
                        .init(name: "test2", type: .int32),
                        .init(name: "test3", type: .uint16),
                        .init(name: "test4", type: .uint8),
                        .init(name: "test5", type: .subStruct(subsut)),
                        .init(name: "test6", type: .abstraction(enum: weekEnum, property: .int8))
                    ]
                )

        XCTAssertEqual(subsut.length, 12)
        XCTAssertEqual(sut.length, 28)
    }

    func testLength5() {
        let subsut = StructDefinition(
            name: "Test1",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint16),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .float),
                .init(name: "test4", type: .int8)
            ]
        )

        let sut = StructDefinition(
                    name: "Test2",
                    wordSize: 4,
                    alignmentStyle: .cStyle,
                    properties: [
                        .init(name: "test1", type: .uint8),
                        .init(name: "test2", type: .array(.subStruct(subsut), count: 5))
                    ]
                )

        XCTAssertEqual(subsut.length, 16)
        XCTAssertEqual(sut.length, 84)
    }

    func testPropertyOffset() {
        let subsut = StructDefinition(
            name: "Test1",
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint16),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .float),
                .init(name: "test4", type: .int8)
            ]
        )

        let sut = StructDefinition(
                    name: "Test2",
                    wordSize: 4,
                    alignmentStyle: .cStyle,
                    properties: [
                        .init(name: "test1", type: .uint8),
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
            wordSize: 4,
            alignmentStyle: .cStyle,
            properties: [
                .init(name: "test1", type: .uint16),
                .init(name: "test2", type: .array(.uint16, count: 3)),
                .init(name: "test3", type: .float),
                .init(name: "test4", type: .int8)
            ]
        )

        let sut = StructDefinition(
                    name: "Test2",
                    wordSize: 4,
                    alignmentStyle: .cStyle,
                    properties: [
                        .init(name: "test1", type: .uint8),
                        .init(name: "test2", type: .subStruct(subsut))
                    ]
                )

        XCTAssertEqual(subsut.length, 16)
        XCTAssertEqual(sut.length, 20)

        XCTAssertEqual(sut.property(for: "test1"), .uint8)
        XCTAssertEqual(sut.property(for: "test2"), .subStruct(subsut))
        XCTAssertEqual(sut.property(for: "test2.test1"), .uint16)
        XCTAssertEqual(sut.property(for: "test2.test2"), .array(.uint16, count: 3))
        XCTAssertEqual(sut.property(for: "test2.test3"), .float)
        XCTAssertEqual(sut.property(for: "test2.test4"), .int8)
    }
}
