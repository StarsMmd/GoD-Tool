//
//  Arrays.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

public extension Array {
    func forEachIndexed(_ closure: (Int,Element) -> Void) {
        for i in 0 ..< self.count {
            closure(i, self[i])
        }
    }
    
    func conditionalAppend(
        _ condition: @autoclosure () -> Bool,
        contents: Self
    ) -> Self {
        condition() ? self + contents : self
    }
}
