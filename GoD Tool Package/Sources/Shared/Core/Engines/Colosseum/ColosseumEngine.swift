//
//  ColosseumEngine.swift
//  
//
//  Created by Stars Momodu on 01/06/2022.
//

import Foundation
import GameCube
import Pokemon


@_exported import GoDEngine
import GoDFoundation

public enum PokemonColosseum {
    public static let engine: CustomEngine = {
        CustomEngine(
            name: "Pokemon Colosseum",
            description: "View and edit files specific to Pokemon Colosseum for the Nintendo Game Cube",
            boolEntries: BooleanEntries.entries,
            integerEntries: IntegerEntries.entries,
            doubleEntries: DoubleEntries.entries,
            stringEntries: StringEntries.entries,
            enumEntries: EnumEntries.entries,
            structEntries: StructEntries.entries
        )
    }()
    
    public static let gameIDJP = "GC6J"
    public static let gameIDUS = "GC6E"
    public static let gameIDEU = "GC6P"
    
    public static let gameIDs = {
        [
            gameIDJP,
            gameIDUS,
            gameIDEU
        ]
    }()
}
