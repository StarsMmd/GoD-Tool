//
//  CacheTests.swift
//  
//
//  Created by Stars Momodu on 31/05/2022.
//

import Foundation
import GoDFoundation
import XCTest

class CacheTests: XCTestCase {
 
    override func setUp() {
        super.setUp()
        File.resetCaches()
        testFolder.delete()
        testFolder.create()
    }
    
    override func tearDown() {
        super.tearDown()
        File.resetCaches()
        testFolder.delete()
    }
    
    func testCaching() {
        let testFile = testFolder.file("test file")
        let testData: GoDData = "test"
        XCTAssertNil(testFile.data)
        XCTAssertNil(testFile.cachedData)
        XCTAssertNil(testFile.permanentCachedData)
        testData.save(to: testFile)
        XCTAssertEqual(testFile.data?.string(format: .utf8), "test")
        XCTAssertEqual(testFile.cachedData?.string(format: .utf8), "test")
        let testData2: GoDData = "edit"
        testData2.save(to: testFile)
        XCTAssertEqual(testFile.data?.string(format: .utf8), "edit")
        XCTAssertEqual(testFile.cachedData?.string(format: .utf8), "test")
        XCTAssertEqual(testFile.permanentCachedData?.string(format: .utf8), "test") // copied from cache
        testFile.removeFromCaches()
        XCTAssertEqual(testFile.data?.string(format: .utf8), "edit")
        XCTAssertEqual(testFile.permanentCachedData?.string(format: .utf8), "edit")
        XCTAssertEqual(testFile.cachedData?.string(format: .utf8), "edit")
        testData.save(to: testFile)
        XCTAssertEqual(testFile.data?.string(format: .utf8), "test")
        XCTAssertEqual(testFile.permanentCachedData?.string(format: .utf8), "edit")
        XCTAssertEqual(testFile.cachedData?.string(format: .utf8), "edit")
        testFile.removeFromCaches()
        XCTAssertEqual(testFile.data?.string(format: .utf8), "test")
        XCTAssertEqual(testFile.cachedData?.string(format: .utf8), "test")
        XCTAssertEqual(testFile.permanentCachedData?.string(format: .utf8), "test")
        testFile.delete()
        XCTAssertNil(testFile.data)
        XCTAssertEqual(testFile.cachedData?.string(format: .utf8), "test")
        XCTAssertEqual(testFile.permanentCachedData?.string(format: .utf8), "test")
        testFile.removeFromCaches()
        XCTAssertNil(testFile.data)
        XCTAssertNil(testFile.cachedData)
        XCTAssertNil(testFile.permanentCachedData)
    }
}
