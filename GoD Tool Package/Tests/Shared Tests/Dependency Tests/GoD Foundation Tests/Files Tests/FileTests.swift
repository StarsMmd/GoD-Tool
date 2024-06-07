//
//  FileTests.swift
//  
//
//  Created by Stars Momodu on 31/05/2022.
//

import Foundation
import GoDFoundation
import XCTest

class GoDFileTests: XCTestCase {
    
    func testInit() {
        let path = "/test/initTest.ext"
        let file = File(path)
        XCTAssertEqual(file.path, path)
        
        let path2 = "initTest/test2"
        let file2 = File(path2)
        XCTAssertEqual(file2.path, path2)
        
        let path3 = "initTest/separator test.ext"
        let file3 = File(path3)
        XCTAssertEqual(file3.path, "initTest/separator test.ext")
    }
    
    func testInitLiteral() {
        let file: File = "literalTest"
        XCTAssertEqual(file.path, "literalTest")
        
        let file2: File = "literalTest/test2"
        XCTAssertEqual(file2.path, "literalTest/test2")
        
        let file3: File = "literalTest/separator test"
        XCTAssertEqual(file3.path, "literalTest/separator test")
    }
    
    func testParent() {
        let sut = File("/root/path/sub path/file name.ext")
        let parent = sut.parentFolder
        XCTAssertEqual(parent?.path, "/root/path/sub path")

        let sut2 = File("/")
        let parent2 = sut2.parentFolder
        XCTAssertNil(parent2?.path)
    }
    
    func testFileType() {
        let sut = File("/test/test file.ext")
        let sut2 = File("/test/test file .bin")
        let sut3 = File("/test/test file")
        XCTAssertEqual(sut.fileType, "ext")
        XCTAssertEqual(sut2.fileType, "bin")
        XCTAssertEqual(sut3.fileType, "")
    }
    
    func testFileName() {
        let sut = File("/test/test file.ext")
        let sut2 = File("/test/test file .bin")
        let sut3 = File("/test/test file")
        XCTAssertEqual(sut.fileName, "test file.ext")
        XCTAssertEqual(sut2.fileName, "test file .bin")
        XCTAssertEqual(sut3.fileName, "test file")
    }
    
    func testFileExtensions() {
        let sut = "folder/file.ext"
        let sut2 = "folder/file.bin.tex"
        XCTAssertEqual(sut.fileExtension, "ext")
        XCTAssertEqual(sut.withoutExtension, "folder/file")
        XCTAssertEqual(sut.fileExtensions, "ext")
        XCTAssertEqual(sut.withoutExtensions, "folder/file")
        XCTAssertEqual(sut2.fileExtension, "tex")
        XCTAssertEqual(sut2.withoutExtension, "folder/file.bin")
        XCTAssertEqual(sut2.fileExtensions, "bin.tex")
        XCTAssertEqual(sut2.withoutExtensions, "folder/file")
    }
}
