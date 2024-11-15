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
    @Published var currentUser: UserBlueprint?
    @Published private var userDictionary: [String: UserBlueprint] = [:] // username: User
    
    static let shared = UserManager()
    
    private init() {}
    
    // Create new user
    func createUser(NewUsername: String, Newpassword: String) -> Bool {
        // Check if username already exists
        guard !userDictionary.keys.contains(NewUsername) else {
            return false
        }
        
        // Create new user
        let newUser = UserBlueprint(username: NewUsername, password: Newpassword)
        userDictionary[NewUsername] = newUser
        return true
    }
    
    // Login existing user
    func login(LoginUsername: String, LoginPassword: String) -> Bool {
        guard 
        let Tempuser = userDictionary[LoginUsername],
              Tempuser.Password == LoginPassword else {
            return false
        }
        
        currentUser = Tempuser
        return true
    }
    
    // Delete user account
    func deleteUser(DelUsername: String, DelPassword: String) -> Bool {
        guard 
        let Tempuser = userDictionary[DelUsername],
        
        Tempuser.Password == DelPassword else {
            return false
        }
        
        users.removeValue(forKey: DelUsername)
        if currentUser?.username == DelUsername {
            logout()
        }
        return true
    }
    
    // Logout current user
    func logout() {
        currentUser = nil
    }
    
    // Check if username exists
    func userExists(_ username: String) -> Bool {
        return users.keys.contains(username)
    }
}