import Foundation
import GoDEngine

enum StringEntries {
    static let entries: [EngineEntry<String>] = [
        systemFileStringConstants,
        userFileStringConstants
    ]
}

let systemFileStringConstants = EngineEntry(
    name: "System File Constants",
    values: [
        "system folder path": "/sys/",
        "executable path": "/sys/main.dol",
        "fst path": "/sys/fst.bin",
        "apploader path": "/sys/apploader.img",
        "bi2 path": "/sys/bi2.bin",
        "boot path": "/sys/boot.bin",
    ]
)

let userFileStringConstants = EngineEntry(
    name: "User File Constants",
    values: [
        "files folder path": "/files/",
    ]
)
