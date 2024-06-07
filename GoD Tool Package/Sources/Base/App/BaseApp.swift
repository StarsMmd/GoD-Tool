//
//  Base.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import SwiftUI
import GoDGUI
import GoDFoundation

public class BaseApp: App {
    
    let themeManager = ThemeManager()
    
    required public init() {}
    
    public var body: some Scene {
        WindowGroup {
            BaseNavigationStackView()
                .environmentObject(themeManager)
                .frame(minWidth: 160, idealWidth: 960, maxWidth: 1440, minHeight: 120, idealHeight: 720, maxHeight: 1080)
        }
        .commandsRemoved()
        .commands {
            CommandMenu("Test Menu") {
                Button("Coming soon..") {
                }
                .keyboardShortcut("p")
            }
        }
        
        Settings {
            VStack {
                Text("Settings")
                Text("Coming soon...")
            }
            .environmentObject(themeManager)
            .frame(minWidth: 160, idealWidth: 960, maxWidth: 1440, minHeight: 120, idealHeight: 720, maxHeight: 1080)
        }
    }
}

struct BaseNavigationStackView: View {
    
    @StateObject var coordinator = Coordinator(root: .filePicker)
    
    var path: Binding<NavigationPath> {
        .init(
            get: { coordinator.navigationPath },
            set: { coordinator.navigationPath = $0 }
        )
    }
    
    public var body: some View {
        NavigationStack(path: path) {
//            filePickerView(isRoot: true)
//                .navigationDestination(for: Routes.self, destination: { [self] route in
//                    switch route {
//                    case .dummy: dummyView()
//                    case .filePicker: filePickerView()
//                    }
//                })
        }
        .frame(minWidth: 160, idealWidth: 960, maxWidth: 1440, minHeight: 120, idealHeight: 720, maxHeight: 1080)
    }
    
    private func dummyView() -> some View {
        Rectangle()
            .foregroundColor(.blue)
            .customNavigation(action: self.coordinator.dismiss(with: nil))
    }
    
//    private func filePickerView(isRoot: Bool = false) -> some View {
//        let viewModel = FilePickerViewModel(
//                            type: .fileOrFolder,
//                            allowedFileTypes: nil,
//                            coordinator: coordinator
//                        )
//        return FilePickerView(viewModel: viewModel)
//            .customNavigation(isShown: !isRoot, action: self.coordinator.dismiss(with: nil))
//    }
}
