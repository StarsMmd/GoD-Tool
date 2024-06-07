import Foundation
import GoDEngine
import Structs

enum StructEntries {
    static let entries: [EngineEntry<StructDefinition>] = [
        systemFileStructConstants
    ]
}

let systemFileStructConstants = EngineEntry(
    name: "System File Constants",
    values: [
        "Boot Data Struct": bootDataStruct,
        "Bi2 Struct": bi2Struct,
        "Apploader Header Struct": apploaderHeaderStruct,
        "Dol Header Struct": dolHeaderStruct,
        "FST Root Struct": fstRootEntryStruct,
        "FST Folder Struct": fstDirectoryEntryStruct,
        "FST File Struct": fstFileEntryStruct,
    ]
)

