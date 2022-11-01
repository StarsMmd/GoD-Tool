//
//  FileSelectorView.swift
//
//
//  Created by Stars Momodu on 03/06/2022.
//

import SwiftUI

open class FileSelectorViewModel: ObservableObject {
    
    public init() {
    }
    
    func presentFilePicker() {
        let viewModel = FilePickerViewModel(type: .fileOrFolder) { paths in
            paths.forEach { path in
                print(path.path)
            }
        }
        let view = FilePickerView(viewModel: viewModel)
    }
}
