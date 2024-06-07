//
//  HexColor.swift
//  
//
//  Created by Stars Momodu on 15/06/2022.
//

import Foundation

public protocol HexColor: ColorValue {
    var rawValue: Int { get }
}

extension HexColor {
    public var red:   UInt8 { return UInt8((rawValue & 0xFF0000) >> 16) }
    public var green: UInt8 { return UInt8((rawValue & 0x00FF00) >> 8) }
    public var blue:  UInt8 { return UInt8((rawValue & 0x0000FF)) }
    public var alpha: UInt8 { return 0xFF }
}
