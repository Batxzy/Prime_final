//
//  SwiftUIView.swift
//  xcode final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI

//MARK: - liked disliked
struct MoviePreference {
    var isLiked: Bool = false
    var isDisliked: Bool = false
}

//MARK: - AuthScreen
enum AuthScreen {
    case createAccount
    case login
    case selectUser
    case deleteAccount
    case welcomeBack
    case editProfile
    case home
}

//MARK: - userClass blueprint
class UserBlueprint: ObservableObject {
    
    @Published var username: String
    @Published var profilePictureName: String
    @Published var likedMovies: Set<Int>      // Stores IDs of liked movies
    @Published var dislikedMovies: Set<Int>   // Stores IDs of disliked movies
    @Published var watchlist: Set<Int>        // Stores IDs of watchlist movies
    @Published var Password: String
    
    
    init(username: String, password: String, profilePictureName: String = "default_profile") {
        self.username = username
        self.profilePictureName = profilePictureName
        self.likedMovies = []
        self.dislikedMovies = []
        self.watchlist = []
        self.Password = password
    }
    
    func toggleLike(for movieId: Int) {
        if likedMovies.contains(movieId) {
            likedMovies.remove(movieId)
        } else {
            likedMovies.insert(movieId)
            dislikedMovies.remove(movieId)  // Remove from dislikes if present
        }
    }
    
    func toggleDislike(for movieId: Int) {
        if dislikedMovies.contains(movieId) {
            dislikedMovies.remove(movieId)
        } else {
            dislikedMovies.insert(movieId)
            likedMovies.remove(movieId)  // Remove from likes if present
        }
    }
    
    func toggleWatchlist(for movieId: Int) {
        if watchlist.contains(movieId) {
            watchlist.remove(movieId)
        } else {
            watchlist.insert(movieId)
        }
    }
}


//MARK: - Class that manages the blueprint
public class UserManager: ObservableObject {
    
    @Published var selectedUserForSwitch: String?
    @Published var currentUser: UserBlueprint?
    @Published var userDictionary: [String: UserBlueprint] = [:] // username: User
    @Published var currentScreen: AuthScreen = .createAccount
    @Published var navigateToEditProfileAfterWelcomeBack: Bool = false  // Add this flag
    
    static let shared = UserManager()
    
    private init() {
        
        let defaultUser = UserBlueprint(
            username: "julian",
            password: "12345",
            profilePictureName: "Furry_1"
        )
        
        userDictionary["julian"] = defaultUser
    }
    
    var userCount: Int {
        return userDictionary.count
    }
    
    
    func navigateToHome() {
        currentScreen = .home
        NavigationManager.shared.navigate(to: .home)
    }
    
    func navigateToEditProfile() {
        
        currentScreen = .editProfile
        NavigationManager.shared.navigate(to: .editProfile)
    }
    
    func navigateToWatchlist() {
        NavigationManager.shared.navigate(to: .watchlist)

    }
    
    func navigateToMovieDetail(_ id: Int) {
        NavigationManager.shared.navigate(to: .movieDetail(id))

    }
    
    
    func removeFromWatchlist(movieId: Int) {
        // Make sure we have a current user
        guard let currentUsername = currentUser?.username else { return }
        
        // Remove the movie ID from the watchlist
        userDictionary[currentUsername]?.watchlist.remove(movieId)
        
        // Update current user reference
        currentUser = userDictionary[currentUsername]
    }
    
    //MARK: - auth functions
    
    // function to switch to user
    func switchToUser(username: String) {
        guard userDictionary[username] != nil else {
            return
        }
        selectedUserForSwitch = username
        NavigationManager.shared.navigate(to: .welcomeBack(username))
    }
    
    // Create new user
    func createUser(newUsername: String, newPassword: String) -> Bool {
        // Check if username already exists
        guard !userDictionary.keys.contains(newUsername) else {
            return false
        }
        // Creates new user
        let newUser = UserBlueprint(username: newUsername, password: newPassword)
        userDictionary[newUsername] = newUser
        currentUser = newUser
        NavigationManager.shared.navigate(to: .home)
        return true
    }
    
    // Login user
    func login(loginUsername: String, loginPassword: String) -> Bool {
        guard
            let tempUser = userDictionary[loginUsername],
            tempUser.Password == loginPassword else {
            return false
        }
        // If switching from another user, logout first
        
        currentUser = tempUser
        selectedUserForSwitch = nil
        NavigationManager.shared.navigate(to: .home)
        return true
    }
    
    // Delete user account
    func deleteUser(delUsername: String, delPassword: String) -> Bool {
        guard
            let tempUser = userDictionary[delUsername],
            
                tempUser.Password == delPassword else {
            return false
        }
        
        userDictionary.removeValue(forKey: delUsername)
        if currentUser?.username == delUsername {
            logout()
        }
        // Determine next screen
        return true
    }
    
    // Logout current user
    func logout() {
        currentUser = nil
        selectedUserForSwitch = nil
        currentScreen = userCount > 0 ? .selectUser : .createAccount
        if userCount > 0 {
            NavigationManager.shared.navigate(to: .selectAccount)
        } else {
            NavigationManager.shared.navigate(to: .createAccount)
        }
    }
    
    // Update user profile
    func updateProfile(newUsername: String, newPassword: String) -> Bool {
        guard let currentUsername = currentUser?.username,
              var user = userDictionary[currentUsername] else {
            return false
        }
        
        user.username = newUsername
        user.Password = newPassword
        userDictionary[newUsername] = user
        currentUser = user
        
        if currentUsername != newUsername {
            userDictionary.removeValue(forKey: currentUsername)
        }
        
        NavigationManager.shared.navigate(to: .home)
        return true
    }
    
    //MARK: - profile picture functions
    
    // Check if username exists
    func userExists(_ username: String) -> Bool {
        return userDictionary.keys.contains(username)
    }
    
    func updateProfilePictureName(to newProfilePic: String) {
        // Update logic for profile picture
        currentUser?.profilePictureName = newProfilePic
    }
    
    func updateProfilePicture(_ pictureName: String) {
        guard
            
            let username = currentUser?.username
        else {
            return
        }
        
        userDictionary[username]?.profilePictureName = pictureName
        currentUser?.profilePictureName = pictureName
    }
}
