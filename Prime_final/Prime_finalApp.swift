import SwiftUI

@main
struct Prime_finalApp: App {
    @State private var navPath = NavigationPath()
    @StateObject private var userManager = UserManager.shared
    @State private var showSplash = true
    @State private var timeRemaining = 2
    @State private var timer: Timer?

    var body: some Scene {
        WindowGroup {
            if showSplash {
                PRIME()
                    .onAppear {
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            } else {
                                timer?.invalidate()
                                showSplash = false
                                
                                // Handle navigation after splash
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
            } else {
                RootView(Navpath: $navPath)
            }
        }
    }
}
