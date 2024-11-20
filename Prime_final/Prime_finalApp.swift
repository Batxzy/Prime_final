import SwiftUI


@main

struct Prime_finalApp: App {
    @State private var navPath = NavigationPath()
    @StateObject private var userManager = UserManager.shared

    var body: some Scene {
        WindowGroup {
            RootView(Navpath: $navPath)
                .onAppear {
                    // Reset navigation path first 
                    navPath = NavigationPath()
                    // Initial routing based on user state
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 2 second delay
                        if userManager.userDictionary.isEmpty {
                            navPath.append(AppRoute.createAccount)
                        } else if userManager.currentUser == nil {
                            navPath.append(AppRoute.selectAccount)
                        } else {
                            navPath.append(AppRoute.home)
                        }
                    }
                }
        }
    }
}
