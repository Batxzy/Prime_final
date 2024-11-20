import SwiftUI

@main
struct Prime_finalApp: App {
    @State private var navPath = NavigationPath()
    @ObservedObject private var userManager = UserManager.shared

    var body: some Scene {
        WindowGroup {
            RootView(Navpath: $navPath)
                .onAppear {
                    if userManager.currentUser != nil {
                        navPath.append(AppRoute.selectAccount)
                    } else {
                        navPath.append(AppRoute.login)
                    }
                }
        }
    }
}
