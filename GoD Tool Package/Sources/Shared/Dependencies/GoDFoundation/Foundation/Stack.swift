//
//  Stack.swift
//  
//
//  Created by Stars Momodu on 01/06/2022.
//

import Foundation

class Stack<T> {
    typealias Element = T

    private var data: [T] = [T]()
    
    func push(_ value: T) {
        data.append(value)
    }
    
    @discardableResult
    func pop() -> T? {
        guard !self.isEmpty else {
            return nil
        }
        return data.removeLast()
    }
    
    func peek() -> T? {
        return data.last
    }
    
    func first() -> T? {
        return data.first
    }
    
    var asArray: [T] {
        let array = self.data
        return array
    }
    
    var count: Int {
        return data.count
    }
    
    var isEmpty: Bool {
        return data.count == 0
    }
}

extension Stack where Element: Equatable {
    func contains(_ element: Element) -> Bool {
        return data.contains(element)
    }
}

extension String {
    var stack: Stack<String> {
        let s = Stack<String>()
        self.reversed().forEach {
            s.push(String($0))
        }
        return s
    }
}

extension Array {
    var stack: Stack<Element> {
        let s = Stack<Element>()
        self.reversed().forEach {
            s.push($0)
        }
        return s
    }
}
