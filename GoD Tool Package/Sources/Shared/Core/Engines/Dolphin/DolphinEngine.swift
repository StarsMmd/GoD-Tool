//
//  DolphinEngine.swift
//  
//
//  Created by Stars Momodu on 05/06/2024.
//

@_exported import GoDEngine
import GoDFoundation

public enum Dolphin {
    public static let engine: CustomEngine = {
        CustomEngine(
            name: "Dolphin",
            description: "View and edit files shared between the Nintendo Dolphin platforms (Gamecube and Wii)",
            boolEntries: BooleanEntries.entries,
            integerEntries: IntegerEntries.entries,
            doubleEntries: DoubleEntries.entries,
            stringEntries: StringEntries.entries,
            enumEntries: EnumEntries.entries,
            structEntries: StructEntries.entries
        )
    }()
}
