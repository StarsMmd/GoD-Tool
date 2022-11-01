

import Foundation
import GoDFoundation

extension GoDReadable {

    public func read(property: StructProperty, atAddress address: Int) -> GoDData? {
        return read(atAddress: address, length: property.length)
    }

    public func read(struct: StructDefinition, atAddress address: Int) -> StructData? {
        guard let data = read(atAddress: address, length: `struct`.length) else {
            return nil
        }
        return StructData(definition: `struct`, data: data)
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
