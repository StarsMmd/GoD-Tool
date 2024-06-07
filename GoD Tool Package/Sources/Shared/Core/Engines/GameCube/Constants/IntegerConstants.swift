import Foundation
import GoDEngine

enum IntegerEntries {
    static let entries: [EngineEntry<Int>] = [
        fstIntegerEntry
    ]
}

let fstIntegerEntry = EngineEntry(
    name: "FST Integer Constants",
    values: [
        "FST Offset Multiplier": 1
    ]
)
