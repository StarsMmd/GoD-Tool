//
//  Routes.swift
//  
//
//  Created by Stars Momodu on 24/04/2023.
//

import GoDFoundation

enum Routes {
    case dummy
    case filePicker
}

enum RouteResult {
    case file(File)
    case files([File])
    case folder(Folder)
    case folders([Folder])
    case path(PathRepresentable)
    case paths([PathRepresentable])
    
    
    var file: File? {
        switch self {
        case .file(let file): return file
        case .files(let files): return files.count > 0 ? files[0] : nil
        case .path(let path): return path as? File
        case .paths(let paths): return paths.count > 0 ? (paths[0] as? File) : nil
        default: return nil
        }
    }
}
