//
//  StackTests.swift
//  
//
//  Created by Stars Momodu on 01/06/2022.
//

import XCTest
@testable import GoDFoundation

class StackTests: XCTestCase {
    
    func testEmpty() {
        let stack1 = Stack<Int>()
        let stack2 = Stack<String>()
        XCTAssertTrue(stack1.isEmpty)
        XCTAssertTrue(stack2.isEmpty)
        XCTAssertEqual(stack1.asArray, [])
        XCTAssertEqual(stack2.asArray, [])
        XCTAssertEqual(stack1.count, 0)
        XCTAssertEqual(stack2.count, 0)
        XCTAssertNil(stack1.peek())
        XCTAssertNil(stack2.peek())
        XCTAssertNil(stack1.pop())
        XCTAssertNil(stack2.pop())
        XCTAssertNil(stack1.first())
        XCTAssertNil(stack2.first())
        XCTAssertFalse(stack1.contains(0))
        XCTAssertFalse(stack2.contains("test"))
    }
    
    func testPushPop() {
        let stack1 = Stack<Int>()
        let stack2 = Stack<String>()
        stack1.push(0)
        stack2.push("test")
        XCTAssertFalse(stack1.isEmpty)
        XCTAssertFalse(stack2.isEmpty)
        XCTAssertEqual(stack1.asArray, [0])
        XCTAssertEqual(stack2.asArray, ["test"])
        XCTAssertEqual(stack1.count, 1)
        XCTAssertEqual(stack2.count, 1)
        XCTAssertEqual(stack1.peek(), 0)
        XCTAssertEqual(stack2.peek(), "test")
        XCTAssertEqual(stack1.first(), 0)
        XCTAssertEqual(stack2.first(), "test")
        XCTAssertTrue(stack1.contains(0))
        XCTAssertTrue(stack2.contains("test"))
        XCTAssertEqual(stack1.pop(), 0)
        XCTAssertEqual(stack2.pop(), "test")
        XCTAssertTrue(stack1.isEmpty)
        XCTAssertTrue(stack2.isEmpty)
        XCTAssertEqual(stack1.asArray, [])
        XCTAssertEqual(stack2.asArray, [])
        XCTAssertEqual(stack1.count, 0)
        XCTAssertEqual(stack2.count, 0)
        XCTAssertNil(stack1.peek())
        XCTAssertNil(stack2.peek())
        XCTAssertNil(stack1.pop())
        XCTAssertNil(stack2.pop())
        XCTAssertNil(stack1.first())
        XCTAssertNil(stack2.first())
        XCTAssertFalse(stack1.contains(0))
        XCTAssertFalse(stack2.contains("test"))
    }
    
    func testPushX2Pop() {
        let stack1 = Stack<Int>()
        let stack2 = Stack<String>()
        stack1.push(0)
        stack1.push(-1)
        stack2.push("test")
        stack2.push("85")
        XCTAssertFalse(stack1.isEmpty)
        XCTAssertFalse(stack2.isEmpty)
        XCTAssertEqual(stack1.asArray, [0, -1])
        XCTAssertEqual(stack2.asArray, ["test", "85"])
        XCTAssertEqual(stack1.count, 2)
        XCTAssertEqual(stack2.count, 2)
        XCTAssertEqual(stack1.peek(), -1)
        XCTAssertEqual(stack2.peek(), "85")
        XCTAssertEqual(stack1.first(), 0)
        XCTAssertEqual(stack2.first(), "test")
        XCTAssertTrue(stack1.contains(0))
        XCTAssertTrue(stack2.contains("test"))
        XCTAssertTrue(stack1.contains(-1))
        XCTAssertTrue(stack2.contains("85"))
        XCTAssertEqual(stack1.pop(), -1)
        XCTAssertEqual(stack2.pop(), "85")
        XCTAssertFalse(stack1.isEmpty)
        XCTAssertFalse(stack2.isEmpty)
        XCTAssertEqual(stack1.asArray, [0])
        XCTAssertEqual(stack2.asArray, ["test"])
        XCTAssertEqual(stack1.count, 1)
        XCTAssertEqual(stack2.count, 1)
        XCTAssertEqual(stack1.peek(), 0)
        XCTAssertEqual(stack2.peek(), "test")
        XCTAssertEqual(stack1.first(), 0)
        XCTAssertEqual(stack2.first(), "test")
        XCTAssertTrue(stack1.contains(0))
        XCTAssertTrue(stack2.contains("test"))
        XCTAssertEqual(stack1.pop(), 0)
        XCTAssertEqual(stack2.pop(), "test")
        XCTAssertTrue(stack1.isEmpty)
        XCTAssertTrue(stack2.isEmpty)
        XCTAssertEqual(stack1.asArray, [])
        XCTAssertEqual(stack2.asArray, [])
        XCTAssertEqual(stack1.count, 0)
        XCTAssertEqual(stack2.count, 0)
        XCTAssertNil(stack1.peek())
        XCTAssertNil(stack2.peek())
        XCTAssertNil(stack1.pop())
        XCTAssertNil(stack2.pop())
        XCTAssertNil(stack1.first())
        XCTAssertNil(stack2.first())
        XCTAssertFalse(stack1.contains(0))
        XCTAssertFalse(stack2.contains("test"))
    }
}
