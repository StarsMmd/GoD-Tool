//
//  Config.swift
//  
//
//  Created by Stars Momodu on 12/06/2022.
//

import Foundation
import GoDFoundation

public final class Config {
    
    @UserDefaultPath("Last Selected Folder") public static var lastSelectedFolder: Folder? = nil
    
    private init() {}
}
