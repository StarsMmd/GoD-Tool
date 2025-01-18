//
//  File.swift
//  
//
//  Created by Stars Momodu on 09/06/2024.
//

import Foundation

struct GoddessSettings: Codable {
    var verbose = false
    
    static var `default`: GoddessSettings {
        GoddessSettings()
    }
}
