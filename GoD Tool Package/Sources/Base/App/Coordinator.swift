//
//  Coordinator.swift
//  
//
//  Created by Stars Momodu on 24/04/2023.
//

import GoDFoundation
import SwiftUI

protocol AppCoordinator {
    func push(route: Routes, onDismiss: RouteResultAction?)
    func dismiss(with result: RouteResult?)
}

typealias RouteResultAction = (RouteResult?) -> Void

final class Coordinator: AppCoordinator, ObservableObject {
    
    struct AppPath {
        let route: Routes
        let onDismiss: RouteResultAction?
    }
    
    @Published var path = [AppPath]()
    @Published var navigationPath = NavigationPath()
    
    init(root: Routes) {
        path.append(.init(route: root, onDismiss: resultHandler))
    }
    
    func push(route: Routes, onDismiss: RouteResultAction?) {
        path.append(.init(route: route, onDismiss: onDismiss))
        navigationPath.append(route)
    }
    
    func dismiss(with result: RouteResult?) {
        guard let last = path.last else {
            return
        }
        
        if path.count > 1 {
            path.removeLast()
        }
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
        last.onDismiss?(result)
    }
    
    func resultHandler(result: RouteResult?) {
        print("result:", result)
        push(route: .dummy, onDismiss: { _ in
            print("dummy dismissed")
        })
    }
}
