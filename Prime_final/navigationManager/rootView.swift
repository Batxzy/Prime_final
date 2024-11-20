import SwiftUI

struct RootView: View {
    @Binding var Navpath : NavigationPath
    @StateObject private var userManager = UserManager.shared

    var mainContent: some View {
        VStack {
            PRIME() // Display Prime Video logo
        }
    }

    var body: some View {
        NavigationStack(path: $Navpath) {
            mainContent
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(path: $Navpath)
                    case .movieDetail(let id):
                        ContentView2(path: $Navpath, CurrentmovieId: id)
                    case .editProfile:
                        EditAccountView(path: $Navpath)
                    case .watchlist:
                        watchlistView()
                    case .login:
                        LoginView(path: $Navpath)
                    case .selectAccount:
                        SelectAccountView(path: $Navpath)
                    case .welcomeBack(let username):
                        welcomeBack(path: $Navpath, selectedUsername: username)
                    case .createAccount:
                        CreateAccountView(path: $Navpath)
                    case .search:
                        LoginView(path: $Navpath)
                    }
                }
        }
        .environmentObject(UserManager())
    }
}
