//
//  CustomNavigation.swift
//  
//
//  Created by Stars Momodu on 25/04/2023.
//

import Foundation
import SwiftUI

extension View {
    func customNavigation(isShown: Bool = true, action: @autoclosure @escaping () -> ()) -> some View {
        modifier(CustomNavigation(isShown: isShown, action: action))
    }
}

private struct CustomNavigation: ViewModifier {
    
    let isShown: Bool
    let action: () -> ()
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if isShown {
                    ToolbarItem(placement: .navigation) {
                        Button(action: action) {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                            }
                        }
                    }
                }
            }
    }
    
}
