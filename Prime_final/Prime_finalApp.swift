import SwiftUI

@main
struct Prime_finalApp: App {
    @State private var navPath = NavigationPath()
    @StateObject private var userManager = UserManager.shared

    var body: some Scene {
            WindowGroup {
                RootView(Navpath: $navPath)
                    .onAppear {
                        // Change initial routing logic
                        if UserManager.shared.userDictionary.isEmpty {
                            navPath.append(AppRoute.createAccount)
                        } else if UserManager.shared.currentUser == nil {
                            navPath.append(AppRoute.selectAccount)
                        } else {
                            navPath.append(AppRoute.home)
                        }
                    }
            }
        }
    }
