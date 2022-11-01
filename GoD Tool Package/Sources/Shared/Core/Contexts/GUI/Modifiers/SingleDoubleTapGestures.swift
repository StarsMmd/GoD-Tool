//
//  File.swift
//  
//
//  Created by Stars Momodu on 13/07/2022.
//

import SwiftUI

public extension View {
    func onTapGesture(single: @escaping () -> Void, double: @escaping () -> Void) -> some View {
        modifier(SingleDoubleTapGesturesModifier(onSingleTap: single, onDoubleTap: double))
    }
}

struct SingleDoubleTapGesturesModifier: ViewModifier {

    let onSingleTap: () -> Void
    let onDoubleTap: () -> Void

    func body(content: Content) -> some View {
        content
            .gesture(
                TapGesture(count: 2).onEnded(onDoubleTap).exclusively(before:
                TapGesture().onEnded(onSingleTap))
            )
    }
}
