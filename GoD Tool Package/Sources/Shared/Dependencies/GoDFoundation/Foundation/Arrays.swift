//
//  Arrays.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation

extension Array {
    func forEachIndexed(_ closure: (Int,Element) -> Void) {
        for i in 0 ..< self.count {
            closure(i, self[i])
        }
    }
}
