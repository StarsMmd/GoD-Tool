//
//  File.swift
//  
//
//  Created by Stars Momodu on 01/06/2022.
//

import Foundation
import GoDFoundation
import GoDFiles

public protocol ISO: DataRepresentable {
    
    var allFiles: [File] { get }
    func getFile(_ file: File) -> GoDData?
    func setFile(_ file: File, toData data: GoDData)
    func getFileSize(_ file: File) -> Int?
    @discardableResult
    func addFile(_ file: File, withData data: GoDData) -> Bool
    @discardableResult
    func deleteFile(_ file: File) -> Bool
    
}
