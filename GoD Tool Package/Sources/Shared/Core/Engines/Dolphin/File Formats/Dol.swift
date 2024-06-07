//
//  Dol.swift
//  
//
//  Created by Stars Momodu on 04/06/2024.
//

import GoDFoundation
import GoDEngine
import Structs

public final class Dol: FileFormat {
    public static let formatName = ".dol"
    
    private let engine: Engine
    
    public var bssSize: UInt32
    public var bssRAMAddress: UInt32
    public var entryPoint: UInt32
    public var textSections: [TextSection]
    public var dataSections: [DataSection]
    
    public init(data: GoDData, engine: Engine) throws {
        self.engine = engine
        
        let dolHeaderStruct: StructDefinition = try engine.get("Dol Header Struct")
        guard let dolHeader = data.read(struct: dolHeaderStruct, atAddress: 0) else {
            throw Self.invalidFileError
        }
        let entryPoint: UInt32 = try dolHeader.entryPoint
        let bssSize: UInt32 = try dolHeader.bssSize
        let bssRAMAddress: UInt32 = try dolHeader.bssRAMAddress
        
        self.bssSize = bssSize
        self.bssRAMAddress = bssRAMAddress
        self.entryPoint = entryPoint
        
        let textSectionsOffsets: [UInt32] = try dolHeader.textSectionsOffsets
        let textSectionsSizes: [UInt32] = try dolHeader.textSectionsSizes
        let textSectionsRAMAddresses: [UInt32] = try dolHeader.textSectionsRAMAddresses
        let dataSectionsOffsets: [UInt32] = try dolHeader.dataSectionsOffsets
        let dataSectionsSizes: [UInt32] = try dolHeader.dataSectionsSizes
        let dataSectionsRAMAddresses: [UInt32] = try dolHeader.dataSectionsRAMAddresses
        
        var textSections = [TextSection]()
        for (offset, size, RAMAddress) in zip3(textSectionsOffsets, textSectionsSizes, textSectionsRAMAddresses) {
            if size > 0, let sectionData = data.read(atAddress: UInt(offset), length: UInt(size)) {
                textSections.append(.init(RAMAddress: RAMAddress, assembly: sectionData))
            } else {
                textSections.append(.init(RAMAddress: RAMAddress, assembly: .none))
            }
        }
        self.textSections = textSections
        
        var dataSections = [DataSection]()
        for (offset, size, RAMAddress) in zip3(dataSectionsOffsets, dataSectionsSizes, dataSectionsRAMAddresses) {
            if size > 0, let sectionData = data.read(atAddress: UInt(offset), length: UInt(size)) {
                dataSections.append(.init(RAMAddress: RAMAddress, data: sectionData))
            } else {
                dataSections.append(.init(RAMAddress: RAMAddress, data: .none))
            }
        }
        self.dataSections = dataSections
    }
    
    public var data: GoDData {
        get throws {
            let dolHeaderStruct: StructDefinition = try engine.get("Dol Header Struct")
            let header = StructData(definition: dolHeaderStruct, byteOrder: .big)
            
            header.bssSize = bssSize
            header.bssRAMAddress = bssRAMAddress
            header.entryPoint = entryPoint
            
            var textSectionOffsets = [UInt32]()
            var textSectionRAMAddresses = [UInt32]()
            var textSectionSizes = [UInt32]()
            var dataSectionOffsets = [UInt32]()
            var dataSectionRAMAddresses = [UInt32]()
            var dataSectionSizes = [UInt32]()
            
            var currentOffset = dolHeaderStruct.length
            
            for i in 0 ... 6 {
                if i < textSections.count {
                    let section = textSections[i]
                    textSectionOffsets.append(currentOffset.unsigned)
                    textSectionRAMAddresses.append(section.RAMAddress)
                    textSectionSizes.append(section.assembly.length.unsigned)
                    currentOffset += section.assembly.length
                } else {
                    textSectionOffsets.append(0)
                    textSectionRAMAddresses.append(0)
                    textSectionSizes.append(0)
                }
            }
            
            for i in 0 ... 10 {
                if i < dataSections.count {
                    let section = dataSections[i]
                    dataSectionOffsets.append(currentOffset.unsigned)
                    dataSectionRAMAddresses.append(section.RAMAddress)
                    dataSectionSizes.append(section.data.length.unsigned)
                    currentOffset += section.data.length
                } else {
                    dataSectionOffsets.append(0)
                    dataSectionRAMAddresses.append(0)
                    dataSectionSizes.append(0)
                }
            }
            
            header.textSectionsOffsets = textSectionOffsets
            header.textSectionsRAMAddresses = textSectionRAMAddresses
            header.textSectionsSizes = textSectionSizes
            header.dataSectionsOffsets = dataSectionOffsets
            header.dataSectionsRAMAddresses = dataSectionRAMAddresses
            header.dataSectionsSizes = dataSectionSizes
            
            let result = header.data
            textSections.forEach {
                result.append($0.assembly)
            }
            dataSections.forEach {
                result.append($0.data)
            }
            return result
        }
    }
}

public extension Dol {
    class TextSection {
        public var RAMAddress: UInt32
        public var assembly: GoDData
        
        public init(RAMAddress: UInt32, assembly: GoDData) {
            self.RAMAddress = RAMAddress
            self.assembly = assembly
        }
    }
    
    class DataSection {
        public var RAMAddress: UInt32
        public var data: GoDData
        
        public init(RAMAddress: UInt32, data: GoDData) {
            self.RAMAddress = RAMAddress
            self.data = data
        }
    }
}
