//
//  Bundle.swift
//  
//
//  Created by Stars Momodu on 31/05/2022.
//

import Foundation
import GoDFoundation

struct Resource {
    static func file(_ name: String) -> File? {
        return File.resource(name, bundle: .module)
    }
}
