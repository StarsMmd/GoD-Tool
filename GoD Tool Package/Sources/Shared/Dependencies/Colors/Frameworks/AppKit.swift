//
//  AppKit.swift
//  
//
//  Created by Stars Momodu on 15/06/2022.
//

#if canImport(AppKit)
import AppKit

public extension ColorValue {
    var nsColor: NSColor {
        return NSColor(red: normalizedRed, green: normalizedGreen, blue: normalizedBlue, alpha: normalizedAlpha)
    }
    
    var cgColor: CGColor {
        return nsColor.cgColor
    }
}
#endif

