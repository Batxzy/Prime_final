import SwiftUI

@main
struct Prime_finalApp: App {
    @State private var navPath = NavigationPath()
    @StateObject private var userManager = UserManager.shared
    @State private var showSplash = true
    @State private var timeRemaining = 8
    @State private var timer: Timer?

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    PRIME()
                        .onAppear {
                            // Start timer only if it hasn't been started
                            if timer == nil {
                                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                    withAnimation {
                                        if timeRemaining > 0 {
                                            timeRemaining -= 1
                                        } else {
                                            timer?.invalidate()
                                            timer = nil
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
                            }
                        }
                        .onDisappear {
                            // Cleanup timer when view disappears
                            timer?.invalidate()
                            timer = nil
                        }
                } else {
                    RootView(Navpath: $navPath)
                }
            }
        }
    }
}