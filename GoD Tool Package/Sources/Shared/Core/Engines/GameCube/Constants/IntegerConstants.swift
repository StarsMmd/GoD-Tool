import Foundation
import GoDEngine

enum IntegerEntries {
    static let entries: [EngineEntry<Int>] = [
        fstIntegerEntry,
        isoIntegerEntry
    ]
}

let fstIntegerEntry = EngineEntry(
    name: "FST Integer Constants",
    values: [
        "FST Offset Multiplier": 1
    ]
)

let isoIntegerEntry = EngineEntry(
    name: "Gamecube ISO Constants",
    values: [
        "max disc capacity": 0x57058000
    ]
)
