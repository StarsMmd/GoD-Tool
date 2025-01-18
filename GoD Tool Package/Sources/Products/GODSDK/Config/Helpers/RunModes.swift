//
//  RunModes.swift
//  
//
//  Created by Stars Momodu on 10/06/2024.
//

import Foundation

enum RunModes {
    case commandLine, development(args: [String])
    
    var arguments: [String] {
        switch self {
        case .commandLine:
            return CommandLine.arguments
        case .development(let args):
            return args
        }
    }
}
