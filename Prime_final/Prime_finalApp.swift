import SwiftUI

@main
struct Prime_finalApp: App {
    @State private var navPath = NavigationPath()
    @StateObject private var userManager = UserManager.shared
    @State private var showSplash = true
    @State private var timeRemaining = 2
    @State private var timer: Timer?

    public  init() {
            // Add default user if needed
            let defaultUser = UserBlueprint(
                username: "Julian",
                password: "12345",
                profilePictureName: "furry1"
            )
            UserManager.shared.userDictionary["Julian"] = defaultUser

        }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    PRIME()
                        .onAppear {
                            print("PRIME view appeared")
                            // Start timer only if it hasn't been started
                            if timer == nil {
                                print("Starting timer...")
                                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                    withAnimation {
                                        if timeRemaining > 0 {
                                            timeRemaining -= 1
                                            print("Time remaining: \(timeRemaining)")
                                        } else {
                                            print("Timer finished")
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
                            print("Cleaning up timer...")
                            timer?.invalidate()
                            timer = nil
                        }
                } else {
                    RootView(Navpath: $navPath)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
