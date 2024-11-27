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
     var likedMovies = Set<Int> ()    
     var dislikedMovies = Set<Int> () 
     var watchlist = Set<Int> ()
     var Password: String
    
    
}


//MARK: - Class that manages the blueprint
public class UserManager: ObservableObject {
    
    @Published var selectedUserForSwitch: String?

    @Published var currentUser: UserBlueprint?

    @Published var userDictionary: [String: UserBlueprint] = [:]
    
    @Published var navigateToEditProfileAfterWelcomeBack: Bool = false
    
    @Published var isComingFromLoginOrDelete: Bool = false
    
    @Published var backButtonlogin: Bool = false
    
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
                profilePictureName: "default1",
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
            
            isComingFromLoginOrDelete = true
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
        
       
        userDictionary.removeValue(forKey: delUsername)
        
        
        if currentUser?.username == delUsername {
            currentUser = nil
        }
        
        isComingFromLoginOrDelete = true
        
        path.wrappedValue = NavigationPath()
        
        
        if userDictionary.isEmpty {
            backButtonlogin = true
            path.wrappedValue.append(AppRoute.login)
        } else {
            
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

   
        func removeFromWatchlist(movieId: Int) {
            
            guard let currentUsername = currentUser?.username else { return }
            
            // Remove the movie ID from the watchlist
            userDictionary[currentUsername]?.watchlist.remove(movieId)
            currentUser?.watchlist.remove(movieId)
            
            
            objectWillChange.send()
        }   

        func addToWatchlist(movieId: Int) {
            
            guard let currentUsername = currentUser?.username else { return }
            
            
            userDictionary[currentUsername]?.watchlist.insert(movieId)
            currentUser?.watchlist.insert(movieId)
            
           
            objectWillChange.send()
        }

    
    func toggleLike(movieId: Int) {
        guard let currentUsername = currentUser?.username else { return }
        
        if currentUser?.likedMovies.contains(movieId) == true {
            // Unlike
            userDictionary[currentUsername]?.likedMovies.remove(movieId)
            currentUser?.likedMovies.remove(movieId)
        } else {
            
            userDictionary[currentUsername]?.likedMovies.insert(movieId)
            currentUser?.likedMovies.insert(movieId)
            
            
            userDictionary[currentUsername]?.dislikedMovies.remove(movieId)
            currentUser?.dislikedMovies.remove(movieId)
        }
        syncUserData()
    }

   
    func toggleDislike(movieId: Int) {
        guard let currentUsername = currentUser?.username else { return }
        
        if currentUser?.dislikedMovies.contains(movieId) == true {
            // Remove dislike
            userDictionary[currentUsername]?.dislikedMovies.remove(movieId)
            currentUser?.dislikedMovies.remove(movieId)
        } else {
            
            userDictionary[currentUsername]?.dislikedMovies.insert(movieId)
            currentUser?.dislikedMovies.insert(movieId)
            
            
            userDictionary[currentUsername]?.likedMovies.remove(movieId)
            currentUser?.likedMovies.remove(movieId)
        }
        syncUserData()
    }
    
//MARK: - profile picture functions

    
    func userExists(_ username: String) -> Bool {
        return userDictionary.keys.contains(username)
    }
    
    
    func updateProfilePictureName(to newName: String) {
        
        currentUser?.profilePictureName = newName
        
        print("new name: \(newName)")
        objectWillChange.send()
    }


    func syncUserData() {
        
        guard var currentUser = currentUser else { return }
        
        
        var userCopy = UserBlueprint(
            username: currentUser.username,
            profilePictureName: currentUser.profilePictureName,
            likedMovies: currentUser.likedMovies,
            dislikedMovies: currentUser.dislikedMovies,
            watchlist: currentUser.watchlist,
            Password: currentUser.Password
        )
        
       
        userCopy.watchlist = currentUser.watchlist
        userCopy.likedMovies = currentUser.likedMovies
        userCopy.dislikedMovies = currentUser.dislikedMovies
        
        
        userDictionary[currentUser.username] = userCopy
        
        
        currentUser = userCopy
        
        
        objectWillChange.send()
    }

}

