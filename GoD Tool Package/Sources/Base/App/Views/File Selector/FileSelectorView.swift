//
//  FileSelectorView.swift
//  
//
//  Created by Stars Momodu on 03/06/2022.
//

import Foundation
import GoDGUI
import GoDFoundation

public struct FileSelectorView: View {
    @ObservedObject private var viewModel: FileSelectorViewModel
    
    public init(viewModel: FileSelectorViewModel) {
        self.viewModel = viewModel
    }
    
    @ViewBuilder
    public var body: some View {
        VStack {
            HStack {
                Button("Pick a file or folder to load") {
                    viewModel.presentFilePicker()
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
    
}
