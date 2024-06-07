

import Foundation
import GoDFoundation

extension GoDReadable {

    public func read(property: StructProperty, atAddress address: Int) -> GoDData? {
        return read(atAddress: address, length: property.length)
    }

    public func read(struct definition: StructDefinition, atAddress address: Int) -> StructData? {
        guard let data = read(atAddress: address, length: definition.length) else {
            return nil
        }
        return StructData(definition: definition, data: data)
    }
    
    public func read(structs definition: StructDefinition, atAddress address: Int, count: Int) -> [StructData]? {
        guard count >= 0 else { return nil }
        guard count > 0 else { return [] }
        
        var structs = [StructData]()
        var currentOffset = address
        for _ in 0 ..< count {
            guard let data = read(struct: definition, atAddress: currentOffset) else {
                return nil
            }
            structs.append(data)
            currentOffset += definition.length
        }
        
        return structs
    }
}

extension GoDWritable {
    
    @discardableResult
    public func write(struct: StructData?, atAddress address: Int) -> Bool {
        guard let data = `struct` else {
            return true
        }
        return write(data.data, atAddress: address)
    }
}
