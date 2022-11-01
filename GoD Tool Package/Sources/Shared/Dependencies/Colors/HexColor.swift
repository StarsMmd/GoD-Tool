//
//  HexColor.swift
//  
//
//  Created by Stars Momodu on 15/06/2022.
//

import Foundation

public protocol HexColor {
    var rawValue: Int { get }
}

extension HexColor: ColorValue {
    var red:   Int { return (rawValue & 0xFF0000) >> 16 }
    var green: Int { return (rawValue & 0x00FF00) >> 16 }
    var blue:  Int { return (rawValue & 0x0000FF) >> 16 }
    var alpha: Int { return 0xFF }
}
