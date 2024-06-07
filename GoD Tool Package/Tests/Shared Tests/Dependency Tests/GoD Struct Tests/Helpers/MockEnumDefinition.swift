//
//  MockEnumDefinition.swift
//  
//
//  Created by Stars Momodu on 06/06/2024.
//

import Foundation
@testable import Structs

let weekEnum = EnumDefinition(name: "DaysOfWeek", values: [
    .init(name: "Monday", rawValue: 0),
    .init(name: "Tuesday", rawValue: 1),
    .init(name: "Wednesday", rawValue: 2),
    .init(name: "Thursday", rawValue: 3),
    .init(name: "Friday", rawValue: 4),
    .init(name: "Satday", rawValue: 5),
    .init(name: "Sunday", rawValue: 6),
])
