//
//  Helpers.swift
//  
//
//  Created by Stars Momodu on 04/06/2024.
//

import Foundation


@inlinable
public func zip3<A, B, C>(_ s1: [A], _ s2: [B], _ s3: [C]) -> [(A,B,C)] {
    let length = min(s1.count, s2.count, s3.count)
    guard length > 0 else { return [] }
    var result = [(A,B,C)]()
    for i in 0 ..< length {
        let v1 = s1[i]
        let v2 = s2[i]
        let v3 = s3[i]
        result.append((v1,v2,v3))
    }
    return result
}
