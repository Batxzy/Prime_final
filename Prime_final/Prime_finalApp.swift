//
//  Prime_finalApp.swift
//  Prime_final
//
//  Created by LAB4CUAAD on 14/11/24.
//

import SwiftUI


@main
struct Prime_finalApp: App {
    @State private var navPath = NavigationPath()

    var body: some Scene {
        WindowGroup {
            RootView(Navpath: $navPath)
        }
    }
}

