//
//  File.swift
//  
//
//  Created by Stars Momodu on 29/09/2022.
//

import Foundation
import GoDFoundation
import GoDEngine

class ISOParser {

    weak var engine: Engine?

    var files: [File: GoDData]
    var folders: [Folder]

    init?(file: File, engine: Engine?) {
        nil
    }

    init?(folder: Folder, engine: Engine?) {
        nil
    }

    func save(to file: File) -> Bool {
        return false
    }

    func save(to folder: Folder) -> Bool {
        return false
    }
}
extension ISOParser: Parser {

    static var description: String { "Load a Gamecube ROM in the ISO format" }

    static func inspect(_ file: File) -> InspectionResult {
        switch file.fileType {
        case "iso", "gcm":
            return .recommendedToParse
        default:
            return .cannotParse
        }
    }

    static func inspect(_ folder: Folder) -> InspectionResult {
        let files = folder.files
        if files.contains(where: { $0.fileType == "dol" }),
           files.contains(where: { $0.fileType == "toc" }) {
            return .recommendedToParse
        }
        return .cannotParse
    }

    static func load(_ file: File, engine: Engine?) -> Parser? {
        ISOParser(file: file, engine: engine)
    }

    static func load(_ folder: Folder, engine: Engine?) -> Parser? {
        ISOParser(folder: folder, engine: engine)
    }

    func parse() -> ParserArtefacts? {
        ParserArtefacts(
            metadata: [
                
            ],
            structs: [

            ],
            structTables: [

            ],
            images: [

            ],
            files: [

            ],
            folders: [

            ],
            actions: [

            ]
        )
    }

    func get(_ artefact: String) -> GoDData? {
        nil
    }

    func set(_ artefact: String, to value: GoDData?) -> Bool {
        false
    }

    func get(_ folder: Folder) -> ParserArtefacts? {
        nil
    }

    func set(_ folder: Folder, to: Folder) -> Bool {
        false
    }

    func performAction(_ action: String, arguments: [String]) -> Bool {
        switch (action, arguments.count) {
        case ("Save to file", 1):
            let file = File(arguments[0])
            return save(to: file)
        case ("Save to folder", 1):
            let folder = Folder(arguments[0])
            return save(to: folder)
        default:
            return false
        }
    }
}
