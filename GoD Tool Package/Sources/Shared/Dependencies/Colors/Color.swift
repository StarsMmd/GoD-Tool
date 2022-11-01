//
//  Color.swift
//  
//
//  Created by Stars Momodu on 15/06/2022.
//

import Foundation

public protocol ColorValue {
    var red: Int { get }
    var green: Int { get }
    var blue: Int { get }
    var alpha: Int { get }
}

public extension ColorValue {
    var normalizedRed: Double { Double(red) / 255 }
    var normalizedGreen: Double { Double(green) / 255 }
    var normalizedBlue: Double { Double(blue) / 255 }
    var normalizedAlpha: Double { Double(alpha) / 255 }
}

public extension ColorValue {
    func integerValue(includeAlpha: Bool = false) -> Int {
        var components = [self.red, self.green, self.blue]
        if includeAlpha {
            components.append(self.alpha)
        }
        var result = 0
        
        for component in components {
            result = result << 8
            result = result | (component & 0xFF)
        }
        
        return result
    }
    
    func hexString(includeAlpha: Bool = false, includeHexPrefix: Bool = true) -> String {
        var result = integerValue(includeAlpha: includeAlpha).hex()
        let expectedLength = includeAlpha ? 8 : 6
        while result.count < expectedLength {
            result = "0" + result
        }
        let prefix = includeHexPrefix ? "0x" : ""
        return prefix + result
    }
}
