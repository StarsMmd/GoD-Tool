import Foundation
import GoDEngine

enum IntegerEntries {
    static let entries: [EngineEntry<Int>] = [
        systemFileIntegerConstants,
        systemDataAlignmentConstants
    ]
}

let systemFileIntegerConstants = EngineEntry(
    name: "System File Constants",
    values: [
        "boot data offset" : 0,
        "bi2 data offset" : 0x440,
        "apploader offset" : 0x2440,
    ]
)

let systemDataAlignmentConstants = EngineEntry(
    name: "System Data Alignment Constants",
    values: [
        "dol offset alignment" : 0x100,
        "fst offset alignment" : 0x100,
        "user offset alignment" : 0x8000,
    ]
)
