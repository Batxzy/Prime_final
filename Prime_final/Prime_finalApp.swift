//
//  Prime_finalApp.swift
//  Prime_final
//
//  Created by LAB4CUAAD on 14/11/24.
//

import SwiftUI

@main
struct Prime_finalApp: App {
    @StateObject private var userManager = UserManager.shared
    
    var body: some Scene {
        WindowGroup {
            if userManager.userCount == 0 {
                CreateAccountView()
            } else if userManager.currentUser == nil {
                SelectAccountView()
            } else {
                HomeView()
            }
        }
    }
}
