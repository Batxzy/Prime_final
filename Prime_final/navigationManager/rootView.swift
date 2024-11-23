import SwiftUI

struct RootView: View {
    @Binding var Navpath : NavigationPath
    @StateObject private var userManager = UserManager.shared

var body: some View {
    NavigationStack(path: $Navpath) {
            PRIME() // Show Prime logo initially
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(path: $Navpath)
                            .navigationBarBackButtonHidden(true)
                    case .movieDetail(let id):
                        ContentView2(path: $Navpath, CurrentmovieId: id)
                    case .editProfile:
                        EditAccountView(path: $Navpath)
                    case .watchlist:
                        watchlistView( path: $Navpath)
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
                    case .settings:
                        SettingsView(path: $Navpath)
                    }
                }
        }
    .environmentObject(UserManager.shared)
    }
}
