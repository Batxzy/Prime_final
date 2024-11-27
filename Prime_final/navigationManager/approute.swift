import SwiftUI

//MARK: - AppRoute list of channels
enum AppRoute: Hashable {
    case home
    case movieDetail(Int)
    case editProfile
    case login
    case watchlist
    case selectAccount
    case welcomeBack(String)
    case createAccount
    case settings
}

enum TabSelection: Hashable {
    case home
    case watchlist
    case search
}


