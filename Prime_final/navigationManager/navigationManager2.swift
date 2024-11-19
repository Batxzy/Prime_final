//
//  navigationManager2.swift
//  Prime_final
//
//  Created by Alumno on 19/11/24.
//

import SwiftUI

// MARK: - NavigationManager remote control
public class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var path = NavigationPath()
    @Published var currentRoute: AppRoute?
    
    func navigate(to route: AppRoute) {
        currentRoute = route
        path.append(route)
    }
    
    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
        if let elements = path.count as? Int, elements > 0 {
            let paths = path.map { $0 as? AppRoute }
            currentRoute = paths.last ?? nil
        } else {
            currentRoute = nil
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
        currentRoute = nil
    }
}