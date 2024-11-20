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
    
    public init() {
        
        let defaultUser = UserBlueprint(
            username: "Julian",
            password: "12345",
            profilePictureName: "furry1"
        )
        defaultUser.watchlist.insert(0)  // Puss in Boots
        defaultUser.watchlist.insert(2)  // Evangelion 1.0
        defaultUser.watchlist.insert(14) // The Dark Knight
    
        // Add some liked/disliked movies
        defaultUser.likedMovies.insert(0)    // Puss in Boots
        defaultUser.likedMovies.insert(8)    // Shrek
        defaultUser.dislikedMovies.insert(7) // Minions

        userDictionary["Julian"] = defaultUser
        currentUser = defaultUser // Set the currentUser to the default user
    }
    
    var userCount: Int {
        return userDictionary.count
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
    func switchToUser(username: String, path: Binding<NavigationPath>) {
        guard userDictionary[username] != nil else { return }
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
        guard let tempUser = userDictionary[loginUsername],
              tempUser.Password == loginPassword else {
            return false
        }
        currentUser = tempUser
        selectedUserForSwitch = nil
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
    
    // Logout current user
     func logout(path: Binding<NavigationPath>) {
        currentUser = nil
        selectedUserForSwitch = nil
        if userCount > 0 {
            path.wrappedValue.append(AppRoute.selectAccount)
        } else {
            path.wrappedValue.append(AppRoute.createAccount)
        }
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


