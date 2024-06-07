//
//  GameCubeEngine.swift
//  
//
//  Created by Stars Momodu on 01/06/2022.
//
@_exported import GoDEngine
import GoDFoundation

public enum GameCube {
    public static let engine: CustomEngine = {
        CustomEngine(
            name: "GameCube",
            description: "View and edit files specific to the Nintendo GameCube platform",
            boolEntries: BooleanEntries.entries,
            integerEntries: IntegerEntries.entries,
            doubleEntries: DoubleEntries.entries,
            stringEntries: StringEntries.entries,
            enumEntries: EnumEntries.entries,
            structEntries: StructEntries.entries
        )
    }()
}
