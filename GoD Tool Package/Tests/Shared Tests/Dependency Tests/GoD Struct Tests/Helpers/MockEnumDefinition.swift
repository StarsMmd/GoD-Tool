//
//  MockEnumDefinition.swift
//  
//
//  Created by Stars Momodu on 06/06/2024.
//

import Foundation
@testable import Structs

let weekEnum = Enum(
    name: "DaysOfWeek",
    allowUnknownCases: false,
    values: [
        .init(name: "Monday", rawValue: 0),
        .init(name: "Tuesday", rawValue: 1),
        .init(name: "Wednesday", rawValue: 2),
        .init(name: "Thursday", rawValue: 3),
        .init(name: "Friday", rawValue: 4),
        .init(name: "Satday", rawValue: 5),
        .init(name: "Sunday", rawValue: 6),
    ],
    propertyType: .uint8
)

let moonPhasesEnum = Enum(
    name: "MoonPhases",
    allowUnknownCases: false,
    values: [
        .init(name: "New", rawValue: 0),
        .init(name: "WaxingCrescent", rawValue: 1),
        .init(name: "Half", rawValue: 2),
        .init(name: "WaxingGibbous", rawValue: 3),
        .init(name: "Full", rawValue: 4),
        .init(name: "WaningGibbous", rawValue: -1),
        .init(name: "WaningCrescent", rawValue: -2),
    ],
    propertyType: .int8
)
