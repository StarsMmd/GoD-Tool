//
//  FilePickerViewModel.swift
//  
//
//  Created by Stars Momodu on 13/06/2022.
//

import Foundation
import GoDFoundation
import SwiftUI
import Config

public final class FilePickerViewModel: ObservableObject {
    @Published var selectedPaths: [PathRepresentable]
    @Published var currentFolder: Folder = {
        Config.lastSelectedFolder ?? Folder.currentWorkingDirectory
    }()
    
    let type: FilePickerType
    let allowedFileTypes: [String]?
    let onSelection: ([PathRepresentable]) -> Void
    
    let shortcuts: [Folder]
    
    public init(type: FilePickerType, allowedFileTypes: [String]? = nil, onSelection: @escaping ([PathRepresentable]) -> Void) {
        self.type = type
        self.allowedFileTypes = allowedFileTypes
        self.onSelection = onSelection
        
        selectedPaths = type == .file ? [] : [Config.lastSelectedFolder ?? Folder.currentWorkingDirectory]
        
        var shortcuts = [Folder]()
        if let lastSelectedFolder = Config.lastSelectedFolder,
           lastSelectedFolder.exists {
            shortcuts.append(lastSelectedFolder)
        }
        if Folder.currentWorkingDirectory.exists,
           !shortcuts.contains(Folder.currentWorkingDirectory) {
            shortcuts.append(Folder.currentWorkingDirectory)
        }
        if Folder.documents.exists,
           !shortcuts.contains(Folder.documents) {
            shortcuts.append(Folder.documents)
        }
        self.shortcuts = shortcuts
    }
    
    func didSelect(paths: [PathRepresentable]) {
        onSelection(paths)
        close()
    }
    
    func close() {

    }
    
    func pickPath(_ path: PathRepresentable) {
        selectedPaths.append(path)
    }
    
    func setFolder(_ folder: Folder) {
        self.currentFolder = folder
        self.selectedPaths = []
        Config.lastSelectedFolder = folder
    }
}
