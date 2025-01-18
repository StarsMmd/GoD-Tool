//
//  XDEngine.swift
//  
//
//  Created by Stars Momodu on 01/06/2022.
//

import Foundation
import GameCube
import Pokemon


@_exported import GoDEngine
import GoDFoundation

public enum PokemonXD {
    public static let engine: CustomEngine = {
        CustomEngine(
            name: "Pokemon XD",
            description: "View and edit files specific to Pokemon XD: Gale of Darkness for the Nintendo Game Cube",
            boolEntries: BooleanEntries.entries,
            integerEntries: IntegerEntries.entries,
            doubleEntries: DoubleEntries.entries,
            stringEntries: StringEntries.entries,
            enumEntries: EnumEntries.entries,
            structEntries: StructEntries.entries
        )
    }()
    
    public static let gameIDJP = "GXXJ"
    public static let gameIDUS = "GXXE"
    public static let gameIDEU = "GXXP"
    
    public static let gameIDs = {
        [
            gameIDJP,
            gameIDUS,
            gameIDEU
        ]
    }()
}
