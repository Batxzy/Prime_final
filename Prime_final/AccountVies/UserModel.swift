//
//  SwiftUIView.swift
//  xcode final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI



//MARK: - userStruct blueprint
struct UserBlueprint: ObservableObject {
    
     var username: String
     var profilePictureName: String
     var likedMovies = Set<Int> ()    // Stores IDs of liked movies
     var dislikedMovies = Set<Int> () // Stores IDs of disliked movies
     var watchlist = Set<Int> ()       // Stores IDs of watchlist movies
     var Password: String
    
    
    init(username: String, password: String, profilePictureName: String = "default_profile") {
        self.username = username
        self.profilePictureName = profilePictureName
        self.likedMovies = []
        self.dislikedMovies = []
        self.watchlist = []
        self.Password = password
    }
}


//MARK: - Class that manages the blueprint
public class UserManager: ObservableObject {
    
    @Published var selectedUserForSwitch: String?

    @Published var currentUser: UserBlueprint?

    @Published var userDictionary: [String: UserBlueprint] = [:] // username: User
    
    @Published var navigateToEditProfileAfterWelcomeBack: Bool = false  // Add this flag
    
    //singleton
    static let shared = UserManager()
    

    //MARK: - init
    public init() {
        userDictionary = [:]
        currentUser = nil
        
    }
    

    //MARK: - computed properties
    var userCount: Int {
        return userDictionary.count
    }
    

//MARK: - user functions

  // Create new user
        func createUser(newUsername: String, newPassword: String, path: Binding<NavigationPath>) -> Bool {
            guard !userDictionary.keys.contains(newUsername) else {
                return false
            }
            let newUser = UserBlueprint(
                username: newUsername, 
                password: newPassword,
                profileptictureName: "default_profile",
                likedMovies: [],
                dislikedMovies: [],
                watchlist: []
                )
            
            userDictionary.append(newUser)
            currentUser = newUser
            path.wrappedValue.append(AppRoute.home)
            return true
        }

    // Logout user
        func logout(path: Binding<NavigationPath>) {
            currentUser = nil
            selectedUserForSwitch = nil
            if userCount > 0 {
                path.wrappedValue.append(AppRoute.selectAccount)
            } else {
                path.wrappedValue.append(AppRoute.createAccount)
            }
        }

    //switch user
        func switchToUser(username: String, path: Binding<NavigationPath>) {
            selectedUserForSwitch = username
            path.wrappedValue.append(AppRoute.welcomeBack(username))
        }

    //Login user
        func login(loginUsername: String, loginPassword: String, path: Binding<NavigationPath>) -> Bool {
            // Verify credentials
            guard let tempUser = userDictionary[loginUsername],
                tempUser.Password == loginPassword else {
                return false
            }
            
            currentUser = tempUser

            selectedUserForSwitch = nil
            path.wrappedValue.append(AppRoute.home)
            return true
        }

    //Delete user account
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
    
//MARK: - movie functions

    // Add movie to watchlist and un add watchlist
        func removeFromWatchlist(movieId: Int) {
            // Make sure we have a current user
            guard let currentUsername = currentUser?.username else { return }
            
            // Remove the movie ID from the watchlist
            userDictionary[currentUsername]?.watchlist.remove(movieId)
            currentUser?.watchlist.remove(movieId)
            
            // Update current user reference
            objectWillChange.send()
        }   

        func addToWatchlist(movieId: Int) {
            // Make sure we have a current user
            guard let currentUsername = currentUser?.username else { return }
            
            // Add the movie ID to the watchlist
            userDictionary[currentUsername]?.watchlist.insert(movieId)
            currentUser?.watchlist.insert(movieId)
            
            // Update current user reference
            objectWillChange.send()
        }

    //like and dislike functions
        func likeMovie(movieId: Int) {
            // Make sure we have a current user
            guard let currentUsername = currentUser?.username else { return }
            
            // Add the movie ID to the liked movies
            userDictionary[currentUsername]?.likedMovies.insert(movieId)
            currentUser?.likedMovies.insert(movieId)
            
            // Remove from disliked movies if present
            userDictionary[currentUsername]?.dislikedMovies.remove(movieId)
            currentUser?.dislikedMovies.remove(movieId)
            
            // Update current user reference
            objectWillChange.send()
        }

        func dislike(movieId: Int) {
            // Make sure we have a current user
            guard let currentUsername = currentUser?.username else { return }
            
            // Add the movie ID to the disliked movies
            userDictionary[currentUsername]?.dislikedMovies.insert(movieId)
            currentUser?.dislikedMovies.insert(movieId)
            
            // Remove from liked movies if present
            userDictionary[currentUsername]?.likedMovies.remove(movieId)
            currentUser?.likedMovies.remove(movieId)
            
            // Update current user reference
            objectWillChange.send()
        }
    
//MARK: - profile picture functions

    // Check if username exists
    func userExists(_ username: String) -> Bool {
        return userDictionary.keys.contains(username)
    }
    
    // Update profile picture name
    func updateProfilePictureName(to newName: String) {
        // Make sure this modifies the currentUser property
        currentUser?.profilePictureName = newName
        
        print("new name: \(newName)")
        objectWillChange.send() // Explicitly notify observers of the change
    }
    
}


func syncUserData() {
        // First check if we have a current user at all
        guard let currentUser = currentUser else { return }
        
        // Create copy with current user's data
        let userCopy = UserBlueprint(
            username: currentUser.username,
            password: currentUser.Password,
            profilePictureName: currentUser.profilePictureName
        )
        
        // Copy collections
        userCopy.watchlist = currentUser.watchlist
        userCopy.likedMovies = currentUser.likedMovies
        userCopy.dislikedMovies = currentUser.dislikedMovies
        
        // Store in dictionary using username directly
        userDictionary[currentUser.username] = userCopy
        objectWillChange.send()
    }