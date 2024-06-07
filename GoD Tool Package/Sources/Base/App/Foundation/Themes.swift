//
//  Themes.swift
//  
//
//  Created by Stars Momodu on 16/07/2023.
//

import Foundation
import GoDFoundation

enum Themes {
    case light
    case dark
    
    fileprivate var implementation: Theme {
        switch self {
        case .light: return LightTheme()
        case .dark: return DarkTheme()
        }
    }
}

protocol Theme {
    var contentPrimary: ColorValue { get }
    var contentSecondary: ColorValue { get }
    var backgroundPrimary: ColorValue { get }
    var backgroundSecondary: ColorValue { get }
    var actionPrimary: ColorValue { get }
    var separator: ColorValue { get }
}

final class ThemeManager: Theme, ObservableObject {
    @Published var currentTheme: Themes = .dark
    
    var contentPrimary: ColorValue {
        currentTheme.implementation.contentPrimary
    }
    var contentSecondary: ColorValue {
        currentTheme.implementation.contentSecondary
    }
    var backgroundPrimary: ColorValue {
        currentTheme.implementation.backgroundPrimary
    }
    var backgroundSecondary: ColorValue {
        currentTheme.implementation.backgroundSecondary
    }
    var actionPrimary: ColorValue {
        currentTheme.implementation.actionPrimary
    }
    
    var separator: ColorValue {
        currentTheme.implementation.separator
    }
}

fileprivate struct LightTheme: Theme {
    var contentPrimary: ColorValue = Colors.Blacks.black
    var contentSecondary: ColorValue = Colors.Grays.darkgray
    var backgroundPrimary: ColorValue = Colors.Grays.lightgray
    var backgroundSecondary: ColorValue = Colors.Whites.white
    var actionPrimary: ColorValue = Colors.Blues.royalblue
    var separator: ColorValue = Colors.Blacks.black.withAlpha(0.5)
}

fileprivate struct DarkTheme: Theme {
    var contentPrimary: ColorValue = Colors.Whites.white
    var contentSecondary: ColorValue = Colors.Grays.lightgray
    var backgroundPrimary: ColorValue = Colors.Blacks.black
    var backgroundSecondary: ColorValue = Colors.Grays.darkgray
    var actionPrimary: ColorValue = Colors.Blues.royalblue
    var separator: ColorValue = Colors.Whites.white.withAlpha(0.5)
}
