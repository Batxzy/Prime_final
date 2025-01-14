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
    
    // ? puede o no haber un usuario es un opcional. tendra que ser manejado para ser usado
    @Published var selectedUserForSwitch: String?

    // aqui necesitaria checar si ocupo esta fakin shit, por que francamente no entiendo el punto de usar un opcional aqui, bueno sabes que si tiene merito, que pase si no tengo ningun usario o si el userblueprint se queda vacio
    @Published var currentUser: UserBlueprint?

    @Published var userDictionary: [String: UserBlueprint] = [:]
    
    @Published var navigateToEditProfileAfterWelcomeBack: Bool = false
    
    @Published var isComingFromLoginOrDelete: Bool = false
    
    @Published var backButtonlogin: Bool = false
    
    //singleton: solo un objeto es creado para manejar todo. el fakin static significa que la clase cada vez que la clase sea intanciada, la propieded le pertenece literal a la clase o al typo de dato que defina. es decir si yo uso el usermanager en cualquier otro lugar la fakin shit va seguir siendo la misma sin importar cuantas veces la intancie y no va pertenecer a la instancia en si
    
    
    static let shared = UserManager()
    

    //MARK: - init
    
    //inicio el diccionario vacio
    public init() {
        userDictionary = [:]
        currentUser = nil
        
    }
    

    //MARK: - computed properties
    
    //dontevent get me fuckin started on this fuck this shit fr fr. this a a closurehtat inside has a closure. absoultly fucking bonkers and deserves its own long form expliananition. el punto  es que esto es una funcion sin la pabablra funcion. asi lo eh entiendido
    
    //esto hace que cada vez que llama al usercount cuente cuantos usuarios tengo con nombre y regresarme el count
    var userCount: Int { return userDictionary.filter { $0.value.username.isEmpty == false }.count}
    

//MARK: - user functions

    // Create new user
    
    //el nav path lo vaz a ver un chingo en este codigo, de ahi me jale para poder controlar la navegacion por stacks. basicamente voy construyendo bloque por bloque el como se va manejando la navegacion
    
        func createUser(newUsername: String, newPassword: String, path: Binding<NavigationPath>) -> Bool {
            
            //de nuevo si el user dictionarny ya tiene un usario igual nel pastel
            guard !userDictionary.keys.contains(newUsername) else {
                return false
            }
            //sino andale creame un nuevo usario con lo que te pusieron como dirian por ahi
            let newUser = UserBlueprint(
                username: newUsername, 
                profilePictureName: "default1",
                likedMovies: [],
                dislikedMovies: [],
                watchlist: [],
                Password: newPassword
                )
            
            //agraga al nuevo usario al diccionario y haslo el current user
            userDictionary[newUsername] = newUser
            currentUser = newUser
            
            
            //accedo al parametro path y le añado que si jala me mande a casita osi osi.
            
            //NOTA: documentar como funciona la navegacion
            path.wrappedValue = NavigationPath()
            path.wrappedValue.append(AppRoute.home)
            return true
        }

    
    // Logout user
        func logout(path: Binding<NavigationPath>) {
            
            // no hay ningun usario
            // scawy
            currentUser = nil
            selectedUserForSwitch = nil
            
            
            //si los usarios son mayor que 0 selecciona una cuenta, sino crea una wey
            if userCount > 0 {
                path.wrappedValue.append(AppRoute.selectAccount)
            } else {
                path.wrappedValue.append(AppRoute.createAccount)
            }
        }

    // switch user
    
    //esta solo la uso una vez y es por que si un usario se queire cambiar a otro, me dio sentido que tenga que poner su contraseña de nuevo asi que cuando te vas a cambiar a un usario que no es el tuyo. sopas que tienes que ir a la pantallas de welcome back, que tiene un paramentro que recibe la info
        func switchToUser(username: String, path: Binding<NavigationPath>) {
            selectedUserForSwitch = username
            path.wrappedValue.append(AppRoute.welcomeBack(username))
        }

    // Login user
        func login(loginUsername: String, loginPassword: String, path: Binding<NavigationPath>) -> Bool {
            
            // Verify credentials, primero creo un usario temporl y accedo a las claves desde el diccionario. si la contraseña no se la misma valio fakin shit
            guard let tempUser = userDictionary[loginUsername],
                tempUser.Password == loginPassword else {
                return false
            }
            
            // si la contraseña es correccta tho, el usario temp se convierte en el current user
            currentUser = tempUser
            
            //unas flags que necesito poner
            isComingFromLoginOrDelete = true
            selectedUserForSwitch = nil
            
            //mas navegacion
            path.wrappedValue = NavigationPath()
            path.wrappedValue.append(AppRoute.selectAccount)
            return true
        }

    // Delete user
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

