//
//  Base.swift
//  
//
//  Created by Stars Momodu on 28/05/2022.
//

import SwiftUI
import GoDGUI

public class BaseApp: App {
    required public init() {}
    
    public var body: some Scene {
        WindowGroup {
            FilePickerView(viewModel: FilePickerViewModel(type: .fileOrFolder, onSelection: {
                print($0)
            }))
                .frame(minWidth: 160, idealWidth: 960, maxWidth: 1440, minHeight: 120, idealHeight: 720, maxHeight: 1080)
        }
        // .commandsRemoved() // uncomment once this is released
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
            .frame(minWidth: 160, idealWidth: 960, maxWidth: 1440, minHeight: 120, idealHeight: 720, maxHeight: 1080)
        }
    }
}

