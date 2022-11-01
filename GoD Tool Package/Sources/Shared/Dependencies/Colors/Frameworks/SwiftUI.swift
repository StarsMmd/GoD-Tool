//
//  SwiftUI.swift
//  
//
//  Created by Stars Momodu on 15/06/2022.
//

#if canImport(SwiftUI)
import SwiftUI

public extension ColorValue {
    var swiftUIColor: Color {
        return Color(red: normalizedRed, green: normalizedGreen, blue: normalizedBlue)
    }
}
#endif
