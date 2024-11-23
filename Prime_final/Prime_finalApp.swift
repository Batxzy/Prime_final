import SwiftUI

@main
struct Prime_finalApp: App {
    @State private var navPath = NavigationPath()
    @StateObject private var userManager = UserManager.shared
    @State private var showSplash = true
    @State private var timeRemaining = 2
    @State private var hasNavigated  = false

    public  init() {
            // Add default user if needed
            let defaultUser = UserBlueprint(
                username: "Julian",
                profilePictureName: "furry1",
                likedMovies: [],
                Password: "12345"
            )
            UserManager.shared.userDictionary["Julian"] = defaultUser
            UserManager.shared.currentUser = defaultUser
        }
    
    var body: some Scene {
           WindowGroup {
               ZStack {
                   if showSplash {
                       PRIME()
                           .onAppear {
                               DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                   withAnimation {
                                       showSplash = false
                                       if !hasNavigated {
                                           navPath.append(AppRoute.login)
                                           hasNavigated = true
                                       }
                                   }
                               }
                           }
                   } else {
                       RootView(Navpath: $navPath)
                   }
               }
               .preferredColorScheme(.dark)
           }
       }
   }
