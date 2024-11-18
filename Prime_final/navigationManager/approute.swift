import SwiftUI

//MARK: - AppRoute list of channels
enum AppRoute: Hashable {
    case home
    case movieDetail(Int)  // Movie ID
    case editProfile
    case watchlist
    case search
    case selectAccount
    case welcomeBack(String) // Username
    case createAccount
}

