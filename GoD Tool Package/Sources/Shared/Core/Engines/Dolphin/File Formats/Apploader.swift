//
//  Apploader.swift
//  
//
//  Created by Stars Momodu on 03/06/2024.
//

import GoDFoundation
import GoDEngine
import Structs

public final class Apploader: FileFormat {
    public static let formatName = "Apploader.img"
    
    private let engine: Engine
    
    public let date: String
    public let entryPoint: UInt32
    public let appCode: GoDData
    public let trailerCode: GoDData
    
    public init(data: GoDData, engine: Engine) throws {
        self.engine = engine
        let apploaderHeaderStruct: StructDefinition = try engine.get("Apploader Header Struct")
        guard let apploaderHeader = data.read(struct: apploaderHeaderStruct, atAddress: 0) else {
            throw Self.invalidFileError
        }
        let date: GoDData = try apploaderHeader.date
        let entryPoint: UInt32 = try apploaderHeader.entryPoint
        let appSize: Int = try apploaderHeader.size
        let trailerSize: Int = try apploaderHeader.trailerSize
        
        self.date = date.string(format: .ascii_big)
        self.entryPoint = entryPoint
        self.appCode = data.read(atAddress: apploaderHeader.length, length: appSize) ?? .none
        self.trailerCode = data.read(atAddress: apploaderHeader.length + appSize, length: trailerSize) ?? .none
    }
    
    public var data: GoDData {
        get throws {
            let apploaderHeaderStruct: StructDefinition = try engine.get("Apploader Header Struct")
            let header = StructData(definition: apploaderHeaderStruct, data: GoDData(length: apploaderHeaderStruct.length, byteOrder: .big))
            
            header.date = date.data(format: .ascii_big)
            header.entryPoint = entryPoint
            header.size = appCode.length
            header.trailerSize = trailerCode.length
            
            let result = header.data
            result.append(appCode)
            result.append(trailerCode)
            return result
        }
    }
}
