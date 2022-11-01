//
//  FolderTests.swift
//  
//
//  Created by Stars Momodu on 31/05/2022.
//

import Foundation
import GoDFoundation
import XCTest

class GoDFolderTests: XCTestCase {
    
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
        let path = "initTest"
        let folder = Folder(path)
        XCTAssertEqual(folder.path, path)
        
        let path2 = "/initTest/test2"
        let folder2 = Folder(path2)
        XCTAssertEqual(folder2.path, path2)
        
        let path3 = "initTest/separator test/"
        let folder3 = Folder(path3)
        XCTAssertEqual(folder3.path, "initTest/separator test")
    }
    
    func testInitLiteral() {
        let folder: Folder = "literalTest"
        XCTAssertEqual(folder.path, "literalTest")
        
        let folder2: Folder = "literalTest/test2"
        XCTAssertEqual(folder2.path, "literalTest/test2")
        
        let folder3: Folder = "literalTest/separator test/"
        XCTAssertEqual(folder3.path, "literalTest/separator test")
    }
    
    func testFolderName() {
        let sut = Folder("/root/folder/sub folder")
        XCTAssertEqual(sut.folderName, "sub folder")
        
        let sut2 = Folder("/root")
        XCTAssertEqual(sut2.folderName, "root")
    }
    
    func testFileVar() {
        let folder = Folder("/testFolderTemp/sub folder")
        let sut = folder.file("file name.ext")
        XCTAssertEqual(sut.path, "/testFolderTemp/sub folder/file name.ext")
        
        let sut2 = folder.file("directory/file name.ext")
        XCTAssertEqual(sut2.path, "/testFolderTemp/sub folder/directory/file name.ext")
    }
    
    func testFolderVar() {
        let folder = Folder("/testFolderTemp/sub folder")
        let sut = folder.folder("folder name")
        XCTAssertEqual(sut.path, "/testFolderTemp/sub folder/folder name")
        
        let sut2 = folder.folder("directory/folder name")
        XCTAssertEqual(sut2.path, "/testFolderTemp/sub folder/directory/folder name")
    }
    
    func testParent() {
        let sut = Folder("/root/path/sub path/directory")
        let parent = sut.parentFolder
        XCTAssertEqual(parent?.path, "/root/path/sub path")
        let grandParent = parent?.parentFolder
        XCTAssertEqual(grandParent?.path, "/root/path")
        let greatParent = grandParent?.parentFolder
        XCTAssertEqual(greatParent?.path, "/root")
        let greatParent2 = greatParent?.parentFolder
        XCTAssertEqual(greatParent2?.path, "/")
        let greatParent3 = greatParent2?.parentFolder
        XCTAssertNil(greatParent3?.path)
    }
    
    func testCreateDelete() {
        let sut = testFolder.folder("createTest")
        XCTAssertFalse(sut.exists)
        XCTAssertTrue(sut.create())
        XCTAssertTrue(sut.exists)
        XCTAssertTrue(sut.delete())
        XCTAssertFalse(sut.exists)
        
        let sut2 = testFolder.folder("createTest/test2")
        XCTAssertFalse(sut.exists)
        XCTAssertFalse(sut2.exists)
        XCTAssertTrue(sut2.create())
        XCTAssertTrue(sut.exists)
        XCTAssertTrue(sut2.exists)
        XCTAssertTrue(sut2.delete())
        XCTAssertTrue(sut.exists)
        XCTAssertFalse(sut2.exists)
        
        let sut3 = testFolder.folder("create test/space test")
        XCTAssertFalse(sut3.exists)
        XCTAssertTrue(sut3.create())
        XCTAssertTrue(sut3.exists)
        XCTAssertTrue(sut3.delete())
        XCTAssertFalse(sut3.exists)
    }
    
    func testFiles() {
        let sut = testFolder.folder("filesTest")
        sut.create()
        (1 ... 5).forEach { id in
            let testFile = sut.file("test file \(id)")
            let testData: GoDData = "Test Data"
            testData.save(to: testFile)
            XCTAssertTrue(testFile.exists)
            let testFolder = sut.folder("test folder \(id)")
            testFolder.create()
            XCTAssertTrue(testFolder.exists)
        }
        XCTAssertEqual(sut.files.count, 5)
        (1 ... 5).forEach { id in
            XCTAssertTrue(sut.contains(sut.file("test file \(id)")))
            XCTAssertTrue(sut.files.contains(sut.file("test file \(id)")))
            XCTAssertFalse(sut.files.contains(sut.folder("test folder \(id)")))
        }
        (6 ... 10).forEach { id in
            XCTAssertFalse(sut.contains(sut.file("test file \(id)")))
            XCTAssertFalse(sut.files.contains(sut.file("test file \(id)")))
        }
    }
    
    func testFolders() {
        let sut = testFolder.folder("filesTest")
        sut.create()
        XCTAssertTrue(sut.exists)
        
        (1 ... 5).forEach { id in
            let testFile = sut.file("test file \(id)")
            let testData: GoDData = "Test Data"
            testData.save(to: testFile)
            XCTAssertTrue(testFile.exists)
            let testFolder = sut.folder("test folder \(id)")
            testFolder.create()
            XCTAssertTrue(testFolder.exists)
        }
        XCTAssertEqual(sut.folders.count, 5)
        (1 ... 5).forEach { id in
            XCTAssertTrue(sut.contains(sut.folder("test folder \(id)")))
            XCTAssertTrue(sut.folders.contains(sut.folder("test folder \(id)")))
            XCTAssertFalse(sut.folders.contains(sut.file("test file \(id)")))
        }
        (6 ... 10).forEach { id in
            XCTAssertFalse(sut.contains(sut.folder("test folder \(id)")))
            XCTAssertFalse(sut.folders.contains(sut.folder("test folder \(id)")))
        }
    }
    
}
