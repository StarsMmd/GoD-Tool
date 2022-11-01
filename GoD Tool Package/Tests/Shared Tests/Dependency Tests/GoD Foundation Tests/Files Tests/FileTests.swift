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
    
    override class func setUp() {
        super.setUp()
        testFolder.delete()
        testFolder.create()
    }
    
    override class func tearDown() {
        super.tearDown()
        testFolder.delete()
    }
    
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
    
    func testCreateDelete() {
        let sut = testFolder.file("createTest.ext")
        let sutData: GoDData = "test data"
        XCTAssertFalse(sut.exists)
        XCTAssertTrue(sutData.save(to: sut))
        XCTAssertTrue(sut.exists)
        XCTAssertEqual(sut.data?.string(format: .utf8), "test data")
        XCTAssertTrue(sut.delete())
        XCTAssertFalse(sut.exists)
    
        let sut2 = testFolder.file("space test.ext")
        let sutData2: GoDData = "test data"
        XCTAssertFalse(sut2.exists)
        XCTAssertTrue(sutData2.save(to: sut2))
        XCTAssertTrue(sut2.exists)
        XCTAssertEqual(sut2.data?.string(format: .utf8), "test data")
        XCTAssertTrue(sut2.delete())
        XCTAssertFalse(sut2.exists)
        
        let sut3 = testFolder.file("folder/folder test.ext")
        let sutData3: GoDData = "test data"
        XCTAssertFalse(sut3.exists)
        XCTAssertTrue(sutData3.save(to: sut3))
        XCTAssertTrue(sut3.exists)
        XCTAssertEqual(sut3.data?.string(format: .utf8), "test data")
        XCTAssertTrue(sut3.delete())
        XCTAssertFalse(sut3.exists)
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
    
    func testResource() {
        let sut = Resource.file("test.txt")
        XCTAssertEqual(sut?.exists, true)
        XCTAssertEqual(sut?.data?.string(format: .utf8), "test\n")
        let sut2 = File.resource("test.txt", bundle: .module)
        XCTAssertEqual(sut2?.exists, true)
        XCTAssertEqual(sut2?.data?.string(format: .utf8), "test\n")
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
    
    func testRename() {
        let sut = testFolder.file("createTest.ext")
        let sutData: GoDData = "test data"
        XCTAssertFalse(sut.exists)
        XCTAssertTrue(sutData.save(to: sut))
        XCTAssertTrue(sut.exists)
        XCTAssertEqual(sut.data?.string(format: .utf8), "test data")
        let sut2 = testFolder.file("renameTest.ext")
        XCTAssertFalse(sut2.exists)
        XCTAssertTrue(sut.rename(sut2.fileName))
        XCTAssertFalse(sut.exists)
        XCTAssertTrue(sut2.exists)
        XCTAssertEqual(sut2.data?.string(format: .utf8), "test data")
        let sut3 = testFolder.file("sub folder/test file.bin")
        XCTAssertFalse(sut3.exists)
        XCTAssertTrue(sut2.move(sut3))
        XCTAssertFalse(sut2.exists)
        XCTAssertTrue(sut3.exists)
        XCTAssertEqual(sut3.data?.string(format: .utf8), "test data")
    }
    
    func testCommonDirectories() {
        let sut = Folder.documents
        XCTAssertEqual(sut.folderName, "Documents")
        
        let sut2 = Folder.currentWorkingDirectory
        XCTAssertEqual(sut2.folderName, "tmp")
    }
}
