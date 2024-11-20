import SwiftUI

//MARK: - RootView the tv
struct RootView: View {
    @Binding var path: NavigationPath
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            mainContent
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(path: $path)
                    case .movieDetail(let id):
                        ContentView2(CurrentmovieId: id, path: $path)
                    case .editProfile:
                        EditAccountView(path: $path)
                    case .watchlist:
                        watchlistView(path: $path)
                    case .login:
                        LoginView(path: $path)
                    case .selectAccount:
                        SelectAccountView(path: $path)
                    case .welcomeBack(let username):
                        welcomeBack(selectedUsername: username, path: $path)
                    case .createAccount:
                        CreateAccountView(path: $path)
                    }
                }
        }
        .environmentObject(userManager)
    }
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
