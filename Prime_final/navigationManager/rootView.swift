import SwiftUI

//MARK: - RootView the tv

struct RootView: View {
    @Binding var Navpath: NavigationPath
    @State private var path = NavigationPath()
    @ObservedObject private var userManager = UserManager.shared
    
    var mainContent: some View {
            VStack {
                Text("")
            }
        }
    
    var body: some View {
        NavigationStack(path: $path) {
            mainContent
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(path: $path)
                    case .movieDetail(let id):
                        ContentView2(path: $path, CurrentmovieId: id)
                    case .editProfile:
                        EditAccountView(path: $path)
                    case .watchlist:
                        watchlistView()
                    case .login:
                        LoginView(path: $path)
                    case .selectAccount:
                        SelectAccountView(path: $path)
                    case .welcomeBack(let username):
                        welcomeBack(path: $path, selectedUsername: username)
                    case .createAccount:
                        CreateAccountView(path: $path)
                    case .search:
                        LoginView(path: $path)
                    }
                }
        }
        .environmentObject(UserManager())
    }
}
