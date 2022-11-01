//
//  FilePickerView.swift
//  
//
//  Created by Stars Momodu on 12/06/2022.
//

import Foundation
import GoDFoundation
import GoDGUI

public enum FilePickerType {
    case file, folder, fileOrFolder
}

public struct FilePickerView: View {
    @ObservedObject var viewModel: FilePickerViewModel

    public init(viewModel: FilePickerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        return GeometryReader { geometry in
            HStack {
                VStack(alignment: .leading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.gray)
                            .opacity(0.5)
                        Text("Shortcuts")
                            .padding()
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom)
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(([viewModel.currentFolder.parentFolder] + viewModel.shortcuts).compactMap{$0}, id: \.path) { folder in
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(.gray)
                                    .opacity(0.25)
                                Text(folder.folderName)
                                    .padding()
                            }
                            .onTapGesture {
                                viewModel.setFolder(folder)
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.trailing)
                .frame(width: geometry.size.width / 4)
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.gray)
                    .opacity(0.5)
                    .padding(.horizontal)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Folder: " + viewModel.currentFolder.path + "/")
                        Spacer()
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.gray)
                            .opacity(0.25)
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 2) {
                                ForEach(viewModel.currentFolder.files.sorted(), id: \.path) { file in
                                    pathCell(file)
                                        .onTapGesture(single: {
                                            if viewModel.type == .file || viewModel.type == .fileOrFolder {
                                                if viewModel.selectedPaths.contains(file) {
                                                    viewModel.selectedPaths = viewModel.selectedPaths.filter { $0.path != file.path }
                                                } else {
                                                    viewModel.selectedPaths.append(file)
                                                }
                                            }
                                        }, double: {
                                            if viewModel.type == .file || viewModel.type == .fileOrFolder {
                                                viewModel.didSelect(paths: [file])
                                            }
                                        })
                                }
                                ForEach(viewModel.currentFolder.folders.sorted(), id: \.path) { folder in
                                    pathCell(folder)
                                        .onTapGesture(single: {
                                            if viewModel.type == .folder || viewModel.type == .fileOrFolder {
                                                if viewModel.selectedPaths.contains(folder) {
                                                    viewModel.selectedPaths = viewModel.selectedPaths.filter { $0.path != folder.path }
                                                } else {
                                                    viewModel.selectedPaths.append(folder)
                                                }
                                            }
                                        }, double: {
                                            viewModel.setFolder(folder)
                                        })
                                }
                            }
                            .padding()
                        }
                        
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            if viewModel.selectedPaths.count == 0 {
                                Text("")
                                Button("Open") {}
                                    .disabled(true)
                            } else if viewModel.selectedPaths.count == 1 {
                                Text("Open: " + viewModel.selectedPaths[0].path)
                                Button("Open") {
                                    viewModel.didSelect(paths: viewModel.selectedPaths)
                                }
                            } else {
                                Text("Open \(viewModel.selectedPaths.count) including: " + viewModel.selectedPaths.last!.path + "...")
                                Button("Open") {
                                    viewModel.didSelect(paths: viewModel.selectedPaths)
                                }
                            }
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    private func pathCell(_ item: PathRepresentable) -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(viewModel.selectedPaths.contains(item) ? .blue : .clear)
                .opacity(0.5)
            HStack {
                Text(item.name)
                Spacer()
            }
            .padding(4)
        }
    }
    
}
