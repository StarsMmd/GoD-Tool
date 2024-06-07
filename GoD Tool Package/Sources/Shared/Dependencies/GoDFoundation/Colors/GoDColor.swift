//
//  GoDColor.swift
//  
//
//  Created by Stars Momodu on 17/07/2023.
//

import Foundation

public struct GoDColor: ColorValue {
    public var red: UInt8
    public var green: UInt8
    public var blue: UInt8
    public var alpha: UInt8
    
    init(red: UInt8 = 0, green: UInt8 = 0, blue: UInt8 = 0, alpha: UInt8 = 255) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}
