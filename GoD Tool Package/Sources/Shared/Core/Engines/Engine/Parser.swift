//
//  Parser.swift
//  
//
//  Created by Stars Momodu on 31/08/2022.
//

import Foundation
import Structs
import GoDFoundation

public enum InspectionResult {
    case canParse
    case recommendedToParse
    case cannotParse
    case unknown
}

public protocol Parser {
    static var description: String { get }
    static func inspect(_ file: File) -> InspectionResult
    static func inspect(_ folder: Folder) -> InspectionResult

    static func load(_ file: File, engine: Engine?) -> Parser?
    static func load(_ folder: Folder, engine: Engine?) -> Parser?

    func parse() -> ParserArtefacts?
    func get(_ artefact: String) -> GoDData?
    func set(_ artefact: String, to value: GoDData?) -> Bool
    func get(_ folder: Folder) -> ParserArtefacts?
    func set(_ folder: Folder, to: Folder) -> Bool

    func performAction(_ action: String, arguments: [String]) -> Bool
}

extension Parser {

    static func load(_ file: File, engine: Engine?) -> Parser? { nil }
    static func load(_ folder: Folder, engine: Engine?) -> Parser? { nil }

    func get<T: ExpressibleByData>(_ variable: ParserArtefacts.Variable) -> T? {
        guard let data = get(variable.title) else { return nil }
        return T(data: data)
    }
    func set<T: DataConvertible>(_ variable: ParserArtefacts.Variable, to value: T?) -> Bool {
        set(variable.title, to: value?.rawData)
    }

    func get(_ structInfo: ParserArtefacts.StructInfo) -> StructData? {
        guard let data = get(structInfo.title) else { return nil }
        return StructData(definition: structInfo.definition, data: data)
    }
    func set(_ structInfo: ParserArtefacts.StructInfo, to value: StructData?) -> Bool {
        set(structInfo.title, to: value?.data)
    }

    func get(_ structTableInfo: ParserArtefacts.StructTableInfo) -> StructTableData? {
        guard let data = get(structTableInfo.title) else { return nil }
        return StructTableData(definition: structTableInfo.definition.definition, data: data)
    }
    func set(_ structTableInfo: ParserArtefacts.StructTableInfo, to value: StructTableData?) -> Bool {
        set(structTableInfo.title, to: value?.data)
    }

    func get(_ file: ParserArtefacts.FileInfo) -> GoDData? {
        get(file.filePath.path)
    }
    func set(_ file: ParserArtefacts.FileInfo, to value: GoDData?) -> Bool {
        set(file.filePath.path, to: value)
    }

    func get(_ folder: Folder) -> ParserArtefacts? {
        nil
    }
    func set(_ folder: Folder, to: Folder) -> Bool {
        false
    }
    func get(_ folder: ParserArtefacts.FolderInfo) -> ParserArtefacts? {
        get(folder.folderPath)
    }
    func set(_ folder: ParserArtefacts.FolderInfo, to: Folder) -> Bool {
        set(folder.folderPath, to: to)
    }

    func performAction(_ action: String, arguments: [String]) -> Bool { false }
    func performAction(_ action: ParserArtefacts.ActionInfo, arguments: [String]) -> Bool {
        performAction(action.name, arguments: arguments)
    }
}

public struct ParserArtefacts {
    public struct Metadata {
        public let title: String
        public let description: String

        public static func named(_ title: String, description: String) -> Metadata {
            .init(title: title, description: description)
        }
    }

    public struct Variable {
        public let title: String
        public let description: String?
        public let value: StructProperty

        public static func named(_ title: String, description: String? = nil, value: StructProperty) -> Variable {
            .init(title: title, description: description, value: value)
        }
    }

    public struct StructInfo {
        public let title: String
        public let description: String?
        public let definition: StructDefinition

        public static func named(_ title: String, description: String? = nil, definition: StructDefinition) -> StructInfo {
            .init(title: title, description: description, definition: definition)
        }
    }

    public struct StructTableInfo {
        public let title: String
        public let description: String?
        public let canExtend: Bool
        public let definition: StructTableDefinition

        public static func named(_ title: String, description: String? = nil, canExtend: Bool, definition: StructTableDefinition) -> StructTableInfo {
            .init(title: title, description: description, canExtend: canExtend, definition: definition)
        }
    }

    public struct ImageInfo {
        public let title: String
        public let description: String?

        public static func named(_ title: String, description: String? = nil) -> ImageInfo {
            .init(title: title, description: description)
        }
    }

    public struct FileInfo {
        public let filePath: File
        public let description: String?

        public static func path(_ filePath: String, description: String? = nil) -> FileInfo {
            .init(filePath: File(filePath), description: description)
        }
    }

    public struct FolderInfo {
        public let folderPath: Folder
        public let files: [FileInfo]
        public let folders: [FolderInfo]
        public let description: String?

        public static func path(_ folderPath: String, files: [FileInfo], folders: [FolderInfo], description: String? = nil) -> FolderInfo {
            .init(folderPath: Folder(folderPath), files: files, folders: folders, description: description)
        }
    }

    public struct ActionInfo {
        public struct ArgumentInfo {
            public indirect enum ArgumentTypes {
                case boolean, integer, integer_unsigned, double, string, file, folder
                case enumCase(EnumDefinition)
                case optional(ArgumentTypes)
            }

            public let name: String
            public let description: String?
            public let defaultValue: String?
            public let type: ArgumentTypes

            public static func named(_ name: String, description: String? = nil, defaultValue: String? = nil, type: ArgumentTypes) -> ArgumentInfo {
                .init(name: name, description: description, defaultValue: defaultValue, type: type)
            }
        }


        public let name: String
        public let description: String?
        public let arguments: [ArgumentInfo]

        public static func named(_ name: String, description: String? = nil, arguments: [ArgumentInfo]) -> ActionInfo {
            .init(name: name, description: description, arguments: arguments)
        }
    }

    public let metadata: [Metadata]
    public let structs: [StructInfo]
    public let structTables: [StructTableInfo]
    public let images:  [ImageInfo]
    public let files: [FileInfo]
    public let folders: [FolderInfo]
    public let actions: [ActionInfo]

    public init(
        metadata: [Metadata],
        structs: [StructInfo],
        structTables: [StructTableInfo],
        images:  [ImageInfo],
        files: [FileInfo],
        folders: [FolderInfo],
        actions: [ActionInfo]
    ) {
        self.metadata = metadata
        self.structs = structs
        self.structTables = structTables
        self.images = images
        self.files = files
        self.folders = folders
        self.actions = actions
    }
}
