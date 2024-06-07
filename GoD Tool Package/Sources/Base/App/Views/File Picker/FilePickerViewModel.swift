////
////  FilePickerViewModel.swift
////  
////
////  Created by Stars Momodu on 13/06/2022.
////
//
//import Foundation
//import GoDFoundation
//import SwiftUI
//import Config
//
//public final class FilePickerViewModel: ObservableObject {
//    @Published var selectedPaths: [PathRepresentable] = []
//    @Published var currentFolder: Folder = {
//        Config.lastSelectedFolder ?? OnDiscFST.shared.currentWorkingDirectory
//    }()
//    
//    let type: FilePickerType
//    let allowedFileTypes: [String]?
//    
//    let shortcuts: [Folder]
//    
//    let coordinator: AppCoordinator
//    
//    init(
//        type: FilePickerType,
//        allowedFileTypes: [String]? = nil,
//        coordinator: AppCoordinator
//    ) {
//        self.type = type
//        self.allowedFileTypes = allowedFileTypes
//        self.coordinator = coordinator
//        
//        var shortcuts = [Folder]()
//        if let lastSelectedFolder = Config.lastSelectedFolder,
//           lastSelectedFolder.exists {
//            shortcuts.append(lastSelectedFolder)
//        }
//        if OnDiscFST.shared.currentWorkingDirectory.exists,
//           !shortcuts.contains(OnDiscFST.shared.currentWorkingDirectory) {
//            shortcuts.append(OnDiscFST.shared.currentWorkingDirectory)
//        }
//        if OnDiscFST.shared.documents.exists,
//           !shortcuts.contains(OnDiscFST.shared.documents) {
//            shortcuts.append(OnDiscFST.shared.documents)
//        }
//        self.shortcuts = shortcuts
//    }
//    
//    func didSelect(paths: [PathRepresentable]) {
//        Config.lastSelectedFolder = currentFolder
//        coordinator.dismiss(with: .paths(paths))
//    }
//    
//    func pickPath(_ path: PathRepresentable) {
//        selectedPaths.append(path)
//    }
//    
//    func setFolder(_ folder: Folder) {
//        self.currentFolder = folder
//        self.selectedPaths = []
//        Config.lastSelectedFolder = folder
//    }
//}
