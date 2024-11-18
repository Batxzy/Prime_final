import SwiftUI

//MARK: - RootView the tv
struct RootView: View {
    @StateObject private var userManager = UserManager.shared
    @StateObject private var navigationManager = NavigationManager.shared
    
    var body: some View {
        NavigationView {
            mainContent
            .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .movieDetail(let id):
                        ContentView2(CurrentmovieId: id)
                    case .editProfile:
                        EditAccountView()
                    case .watchlist:
                        watchlistView()
                    case .search:
                        // Add your search view
                        EmptyView()
                    case .selectAccount:
                        SelectAccountView()
                    case .welcomeBack(let username):
                        welcomeBack(selectedUsername: username)
                    case .createAccount:
                        CreateAccountView()
                    }
                }
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