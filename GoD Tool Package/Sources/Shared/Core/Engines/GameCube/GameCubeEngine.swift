//
//  GameCubeEngine.swift
//  
//
//  Created by Stars Momodu on 01/06/2022.
//

import Foundation
import GoDFoundation
import GoDEngine
import Structs

public enum Gamcube {
    public static var engine: Engine {
        GameCubeEngine()
    }
}

class GameCubeEngine: Engine {

    var name: String { "GameCube" }
    var description: String { "View and edit files specific to the Nintendo GameCube platform" }
    var parsers: [Parser.Type] { gamecubeParsers }

    fileprivate init() {}
    
    func getConstant(_ name: String) -> Bool? {
        booleanConstants[name]
    }

    func getConstant(_ name: String) -> Double? {
        doubleConstants[name]
    }

    func getConstant(_ name: String) -> Int? {
        integerConstants[name]
    }

    func getConstant(_ name: String) -> String? {
        stringConstants[name]
    }

    func getEnumDefinition(_ name: String) -> EnumDefinition? {
        enumDefinitions[name]
    }

    func getStructDefinition(_ name: String) -> StructDefinition? {
        structDefinitions[name]
    }
}
