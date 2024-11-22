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
        if let username = UserManager.shared.currentUser?.username{
            UserManager.shared.userDictionary[username] = self
            UserManager.shared.saveUserPreferences()
        }
        objectWillChange.send()
    }
    
    func toggleDislike(for movieId: Int) {
        if dislikedMovies.contains(movieId) {
            dislikedMovies.remove(movieId)
        } else {
            dislikedMovies.insert(movieId)
            likedMovies.remove(movieId)  // Remove from likes if present
        }
        UserManager.shared.userDictionary[username] = self
        UserManager.shared.saveUserPreferences()

        objectWillChange.send()
    }
    
    func toggleWatchlist(for movieId: Int) {
        if watchlist.contains(movieId) {
            watchlist.remove(movieId)
        } else {
            watchlist.insert(movieId)
        }
        if let username = UserManager.shared.currentUser?.username{
            UserManager.shared.userDictionary[username] = self
            UserManager.shared.saveUserPreferences()
        }
    }
}


//MARK: - Class that manages the blueprint
public class UserManager: ObservableObject {
    
    @Published var selectedUserForSwitch: String?
    @Published var currentUser: UserBlueprint?
    @Published var userDictionary: [String: UserBlueprint] = [:] // username: User
    @Published var navigateToEditProfileAfterWelcomeBack: Bool = false  // Add this flag
    
    private let   defaults: UserDefaults = .standard
    
    static let shared = UserManager()
    
    public init() {
           loadUserPreferences() 
    }
    
    var userCount: Int {
        return userDictionary.count
    }
    

    func saveUserPreferences() {
        // Save each user's preferences separately
        for (username, user) in userDictionary {
            let userKey = "user_\(username)"
            let preferences: [String: Any] = [
                "username": user.username,
                "profilePictureName": user.profilePictureName,
                "likedMovies": Array(user.likedMovies),
                "dislikedMovies": Array(user.dislikedMovies), 
                "watchlist": Array(user.watchlist),
                "password": user.Password
            ]
            defaults.set(preferences, forKey: userKey)
        }
        // Save list of usernames
        defaults.set(Array(userDictionary.keys), forKey: "userList")
    }

    private func loadUserPreferences() {
        guard let usernames = defaults.array(forKey: "userList") as? [String] else { return }
        
        for username in usernames {
            let userKey = "user_\(username)"
            guard let preferences = defaults.dictionary(forKey: userKey) else { continue }
            
            let user = UserBlueprint(
                username: preferences["username"] as? String ?? "",
                password: preferences["password"] as? String ?? "",
                profilePictureName: preferences["profilePictureName"] as? String ?? "default_profile"
            )
            
            // Restore preferences
            if let liked = preferences["likedMovies"] as? [Int] {
                user.likedMovies = Set(liked)
            }
            if let disliked = preferences["dislikedMovies"] as? [Int] {
                user.dislikedMovies = Set(disliked)
            }
            if let watchlist = preferences["watchlist"] as? [Int] {
                user.watchlist = Set(watchlist)
            }
            
            userDictionary[username] = user
        }
        objectWillChange.send()
    }


   func logout(path: Binding<NavigationPath>) {
    currentUser = nil
    selectedUserForSwitch = nil
    if userCount > 0 {
        path.wrappedValue.append(AppRoute.selectAccount)
    } else {
        path.wrappedValue.append(AppRoute.createAccount)
    }
}
    
    func syncUserData() {
    guard let username = currentUser?.username else { return }
    userDictionary[username] = currentUser
    saveUserPreferences() // Save after syncing
    objectWillChange.send()
}

    func removeFromWatchlist(movieId: Int) {
        // Make sure we have a current user
        guard let currentUsername = currentUser?.username else { return }
        
        // Remove the movie ID from the watchlist
        userDictionary[currentUsername]?.watchlist.remove(movieId)
        currentUser?.watchlist.remove(movieId)
        
        // Update current user reference
        objectWillChange.send()
    }
    
    //MARK: - auth functions
    
    // function to switch to user
    func switchToUser(username: String, path: Binding<NavigationPath>) {
    selectedUserForSwitch = username
    path.wrappedValue.append(AppRoute.welcomeBack(username))
    }
    
    // Create new user
    func createUser(newUsername: String, newPassword: String, path: Binding<NavigationPath>) -> Bool {
        guard !userDictionary.keys.contains(newUsername) else {
            return false
        }
        let newUser = UserBlueprint(username: newUsername, password: newPassword)
        
        
        userDictionary[newUsername] = newUser
        currentUser = newUser
        path.wrappedValue.append(AppRoute.home)
        return true
    }
    
    // Login user
    func login(loginUsername: String, loginPassword: String, path: Binding<NavigationPath>) -> Bool {
    // First save current user's data if it exists
    if let currentUsername = currentUser?.username {
        userDictionary[currentUsername] = currentUser
    }
    
    // Then attempt to login as new user
    guard let tempUser = userDictionary[loginUsername],
          tempUser.Password == loginPassword else {
        return false
    }
    
    // Update current user and sync data
    currentUser = tempUser
    selectedUserForSwitch = nil
    syncUserData() // Make sure to sync after switching
    
    path.wrappedValue.append(AppRoute.home)
    return true
}
    
    // Delete user account
    func deleteUser(delUsername: String, delPassword: String, path: Binding<NavigationPath>) -> Bool {
        guard
            let tempUser = userDictionary[delUsername],
            tempUser.Password == delPassword else {
            return false
        }
        
        userDictionary.removeValue(forKey: delUsername)
        if currentUser?.username == delUsername {
            logout(path: path)
        }
        
        // Navigate based on remaining users
        if userCount > 0 {
            path.wrappedValue.append(AppRoute.selectAccount)
        } else {
            path.wrappedValue.append(AppRoute.createAccount)
        }
        return true
    }
        
    
    // Update user profile
    func updateProfile(newUsername: String, newPassword: String, path: Binding<NavigationPath>) -> Bool {
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
        
        path.wrappedValue.append(AppRoute.home)
        return true
    }
    
//MARK: - profile picture functions
    
    // Check if username exists
    func userExists(_ username: String) -> Bool {
        return userDictionary.keys.contains(username)
    }
    
    func updateProfilePictureName(to newName: String) {
        // Make sure this modifies the currentUser property
        currentUser?.profilePictureName = newName
        
        print("new name: \(newName)")
        objectWillChange.send() // Explicitly notify observers of the change
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


