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
class UserManager: ObservableObject {
    @Published var selectedUserForSwitch: String?
    @Published var currentUser: UserBlueprint?
    @Published private var userDictionary: [String: UserBlueprint] = [:] // username: User
    @Published var currentScreen: AuthScreen = .createAccount

    static let shared = UserManager()
    
    private init() {}
    
    var userCount: Int {
        return userDictionary.count
    }

    // function to switch to user
    func switchToUser(Switchusername: String) {
    // Validate user exists before allowing switch
    guard userDictionary[Switchusername] != nil else { 
        return
    }
    selectedUserForSwitch = Switchusername
    currentScreen = .welcomeBack
}
    // Create new user
    func createUser(newUsername: String, newPassword: String) -> Bool {
        // Check if username already exists
        guard !userDictionary.keys.contains(newUsername) else {
            return false
        }
        
        // Create new user
        let newUser = UserBlueprint(username: newUsername, password: newPassword)
        userDictionary[newUsername] = newUser
        return true
    }
    
    // Login existing user
    func login(loginUsername: String, loginPassword: String) -> Bool {
        guard 
        let tempUser = userDictionary[loginUsername],
              tempUser.Password == loginPassword else {
            return false
        }
        // If switching from another user, logout first
   
        selectedUserForSwitch = nil // Clear selected user after successful switch
        currentScreen = .home // Or whatever your main screen is
        currentUser = tempUser
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
        currentScreen = userCount > 0 ? .selectUser : .createAccount
        return true
    }
    // Logout current user
    func logout() {
        currentUser = nil
        selectedUserForSwitch = nil
        currentUser = nil
        currentScreen = userCount > 0 ? .selectUser : .createAccount
    }
    
    // Check if username exists
    func userExists(_ username: String) -> Bool {
        return userDictionary.keys.contains(username)
    }
}