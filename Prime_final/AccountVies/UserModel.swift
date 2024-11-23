//
//  SwiftUIView.swift
//  xcode final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI



//MARK: - userStruct blueprint
struct UserBlueprint {
    
     var username: String
     var profilePictureName: String
     var likedMovies = Set<Int> ()    // Stores IDs of liked movies
     var dislikedMovies = Set<Int> () // Stores IDs of disliked movies
     var watchlist = Set<Int> ()       // Stores IDs of watchlist movies
     var Password: String
    
    
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
        return userDictionary.filter { $0.value.username.isEmpty == false }.count
    }
    

//MARK: - user functions

    // Create new user
        func createUser(newUsername: String, newPassword: String, path: Binding<NavigationPath>) -> Bool {
            guard !userDictionary.keys.contains(newUsername) else {
                return false
            }
            let newUser = UserBlueprint(
                username: newUsername, 
                profilePictureName: "default_profile",
                likedMovies: [],
                dislikedMovies: [],
                watchlist: [],
                Password: newPassword
                )
            
            userDictionary[newUsername] = newUser
            currentUser = newUser
            path.wrappedValue = NavigationPath()
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

    // switch user
        func switchToUser(username: String, path: Binding<NavigationPath>) {
            selectedUserForSwitch = username
            path.wrappedValue.append(AppRoute.welcomeBack(username))
        }

    // Login user
        func login(loginUsername: String, loginPassword: String, path: Binding<NavigationPath>) -> Bool {
            // Verify credentials
            guard let tempUser = userDictionary[loginUsername],
                tempUser.Password == loginPassword else {
                return false
            }
            
            currentUser = tempUser

            selectedUserForSwitch = nil
            path.wrappedValue = NavigationPath()
            path.wrappedValue.append(AppRoute.selectAccount)
            return true
        }

    // In UserModel.swift

    func deleteUser(delUsername: String, delPassword: String, path: Binding<NavigationPath>) -> Bool {
        guard
            let tempUser = userDictionary[delUsername],
            tempUser.Password == delPassword else {
            return false
        }
        
        // Remove user from dictionary
        userDictionary.removeValue(forKey: delUsername)
        
        // Clear current user if it's the one being deleted
        if currentUser?.username == delUsername {
            currentUser = nil
        }

        // Reset navigation path
        path.wrappedValue = NavigationPath()
        
        // Navigate based on remaining users
        if userDictionary.isEmpty {
            // If no users left, go to login
            path.wrappedValue.append(AppRoute.login)
        } else {
            // If users remain, go to select account
            path.wrappedValue.append(AppRoute.selectAccount)
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
    
    // delete path
        private func cleanupNavigation(_ path: Binding<NavigationPath>) {
            if path.wrappedValue.count > 0 {
                path.wrappedValue.removeLast()
            }
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

    // In UserManager class, replace the toggleLike function with:
    func toggleLike(movieId: Int) {
        guard let currentUsername = currentUser?.username else { return }
        
        if currentUser?.likedMovies.contains(movieId) == true {
            // Unlike
            userDictionary[currentUsername]?.likedMovies.remove(movieId)
            currentUser?.likedMovies.remove(movieId)
        } else {
            // Like and remove from disliked if it exists
            userDictionary[currentUsername]?.likedMovies.insert(movieId)
            currentUser?.likedMovies.insert(movieId)
            
            // Remove from disliked if present
            userDictionary[currentUsername]?.dislikedMovies.remove(movieId)
            currentUser?.dislikedMovies.remove(movieId)
        }
        syncUserData()
    }

    // Replace the toggleDislike function with:
    func toggleDislike(movieId: Int) {
        guard let currentUsername = currentUser?.username else { return }
        
        if currentUser?.dislikedMovies.contains(movieId) == true {
            // Remove dislike
            userDictionary[currentUsername]?.dislikedMovies.remove(movieId)
            currentUser?.dislikedMovies.remove(movieId)
        } else {
            // Dislike and remove from liked if it exists
            userDictionary[currentUsername]?.dislikedMovies.insert(movieId)
            currentUser?.dislikedMovies.insert(movieId)
            
            // Remove from liked if present
            userDictionary[currentUsername]?.likedMovies.remove(movieId)
            currentUser?.likedMovies.remove(movieId)
        }
        syncUserData()
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
    // Remove the comment marks and update the syncUserData function:
    func syncUserData() {
        // First check if we have a current user at all
        guard var currentUser = currentUser else { return }
        
        // Since UserBlueprint is now a struct (value type), creating a copy is safe
        var userCopy = UserBlueprint(
            username: currentUser.username,
            profilePictureName: currentUser.profilePictureName,
            likedMovies: currentUser.likedMovies,
            dislikedMovies: currentUser.dislikedMovies,
            watchlist: currentUser.watchlist,
            Password: currentUser.Password
        )
        
        // Copy collections - this creates new Sets since Set is a value type
        userCopy.watchlist = currentUser.watchlist
        userCopy.likedMovies = currentUser.likedMovies
        userCopy.dislikedMovies = currentUser.dislikedMovies
        
        // Update dictionary with the new copy
        userDictionary[currentUser.username] = userCopy
        
        // Update currentUser to match
        currentUser = userCopy
        
        // Notify observers
        objectWillChange.send()
    }

}

