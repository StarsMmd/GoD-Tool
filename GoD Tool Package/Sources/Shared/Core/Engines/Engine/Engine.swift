//
//  Engine.swift
//  
//
//  Created by Stars Momodu on 09/08/2022.
//

import Foundation
import GoDFoundation
import Structs

public protocol Engine: AnyObject {
    var name: String { get }
    var description: String { get }
    var parsers: [Parser.Type] { get }

    func getConstant(_ name: String) -> Bool?
    func getConstant(_ name: String) -> Int?
    func getConstant(_ name: String) -> String?
    func getConstant(_ name: String) -> Double?

    func getEnumDefinition(_ name: String) -> EnumDefinition?
    func getStructDefinition(_ name: String) -> StructDefinition?
}

public extension Engine {
    func getConstant(_ name: String) -> Bool? { nil }
    func getConstant(_ name: String) -> Int? { nil }
    func getConstant(_ name: String) -> String? { nil }
    func getConstant(_ name: String) -> Double? { nil }

    func getEnumDefinition(_ name: String) -> EnumDefinition? { nil }
    func getStructDefinition(_ name: String) -> StructDefinition? { nil }
}

public extension Engine {
    func inspect(_ file: File) -> InspectionResult {
        parsers.reduce(.cannotParse) { topResult, parser in
            let inspectionResult = parser.inspect(file)
            switch (inspectionResult, topResult) {
            case (.recommendedToParse, _), (_, .recommendedToParse):
                return .recommendedToParse
            case (.canParse, _), (_, .canParse):
                return .canParse
            case (.unknown, _), (_, .unknown):
                return .unknown
            case (.cannotParse, _), (_, .cannotParse):
                return .cannotParse
            }
        }
    }

    func inspect(_ folder: Folder) -> InspectionResult {
        parsers.reduce(.cannotParse) { topResult, parser in
            let inspectionResult = parser.inspect(folder)
            switch (inspectionResult, topResult) {
            case (.recommendedToParse, _), (_, .recommendedToParse):
                return .recommendedToParse
            case (.canParse, _), (_, .canParse):
                return .canParse
            case (.unknown, _), (_, .unknown):
                return .unknown
            case (.cannotParse, _), (_, .cannotParse):
                return .cannotParse
            }
        }
    }
}
