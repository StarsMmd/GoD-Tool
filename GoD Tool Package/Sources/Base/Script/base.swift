//
//  main.swift
//
//
//  Created by Stars Momodu on 28/05/2022.
//

import Foundation
import GoDFoundation
import GoDFiles

public func main() {
    let folder = Folder.documents
    print(folder.path)
    let file = File("/Users/starsmomodu/Documents/test.txt")
    file.data?.length.println()
}
