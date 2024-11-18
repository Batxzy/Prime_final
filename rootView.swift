import SwiftUI

//MARK: - RootView the tv
struct RootView: View {
    @StateObject private var userManager = UserManager.shared
    @StateObject private var navigationManager = NavigationManager.shared
    
    var body: some View {
        NavigationView {
            mainContent
                .navigationBarHidden(true)
        }
        .environmentObject(userManager)
        .environmentObject(navigationManager)
    }
    
    @ViewBuilder
    private var mainContent: some View {
        if userManager.userCount == 0 {
            CreateAccountView()
        } else if userManager.currentUser == nil {
            SelectAccountView()
        } else {
            HomeView()
        }
    }
}