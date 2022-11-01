//
//  File.swift
//  
//
//  Created by Stars Momodu on 31/07/2022.
//

import Foundation

public struct Environment {

    public static let byteOrder: ByteOrder = {
        switch CFByteOrderGetCurrent() {
        case CFByteOrderBigEndian.rawValue.asInt: return .big
        case CFByteOrderLittleEndian.rawValue.asInt: return .little
        default: return .unspecified
        }
    }()

    public static let wordSize: Int = {
        return Int.bitWidth / 8
    }()

    #if os(macOS)
    public static let platform: Platforms = .macOS
    #elseif os(iOS)
    public static let platform: Platforms = .iOS
    #elseif os(Windows)
    public static let platform: Platforms = .Windows
    #elseif os(Linux)
    public static let platform: Platforms = .Linux
    #else
    public static let platform: Platforms = .unknown
    #endif
}
