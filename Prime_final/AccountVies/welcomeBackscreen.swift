import SwiftUI

struct welcomeBack: View {


//MARK: - interoperabilty
    @Binding var path: NavigationPath
    @EnvironmentObject private var userManager: UserManager
    let selectedUsername: String

//MARK: - State variables
    @State private var password: String = ""
    @State private var isSecured: Bool = true
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
//MARK: - Functions   
    private func handleLogin() {
        guard let user = userManager.userDictionary[selectedUsername],
              user.Password == password else {
            showError = true
            errorMessage = "Invalid password"
            return
        }
        
        // Create fresh instance with all data
        userManager.currentUser = UserBlueprint(
            username: user.username,
            profilePictureName: user.profilePictureName,
            likedMovies: user.likedMovies
            ,Password: user.Password
        )
        userManager.currentUser?.watchlist = user.watchlist
        userManager.currentUser?.likedMovies = user.likedMovies
        userManager.currentUser?.dislikedMovies = user.dislikedMovies
        
        // Sync data before navigation
        //$userManager.syncUserData
        
        if userManager.navigateToEditProfileAfterWelcomeBack {
            path.append(AppRoute.editProfile)
            userManager.navigateToEditProfileAfterWelcomeBack = false
        } else {
            path.append(AppRoute.home)
        }
    }

//MARK: - Body
    var body: some View {
            Group {
            if let user = userManager.userDictionary[selectedUsername] {
                
                //main view
                ZStack {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .black, location: 0.28),
                            Gradient.Stop(color: Color(red: 0.03, green: 0.16, blue: 0.27), location: 0.65),
                            Gradient.Stop(color: Color(red: 0.1, green: 0.6, blue: 1), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 50) {
                    VStack(alignment: .center, spacing: 25) {
                        Text("Welcome Back")
                            .font(.title.bold())
                            .foregroundColor(.white)

                        VStack(alignment: .center, spacing: 10){
                                Image(userManager.userDictionary[selectedUsername]?.profilePictureName ?? "profile")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(.circle)
                                .frame(width:85, height:85)
                        }
                    }   
                    VStack(alignment: .leading) {
                        // Password
                        Text("Password")
                        .font(.callout.bold()).foregroundColor(.white)
                        HStack(){
                            if isSecured {
                                        AnyView(SecureField("Password", text: $password)
                                            .preferredColorScheme(.dark)
                                            .frame(maxWidth: .infinity, minHeight: 58))
                                    } else {
                                        AnyView(TextField("Password", text: $password)
                                            .preferredColorScheme(.dark)
                                            .frame(maxWidth: .infinity, minHeight: 58))
                                    }
                                    
                                    Spacer()
                                    
                            Button(action: {
                                            isSecured.toggle()
                                        }) {
                                            Image(systemName: isSecured ? "eye.fill" : "eye.slash.fill")
                                                .foregroundStyle(.white.opacity(0.8))
                                        }
                                    }
                                .padding(10)
                                .frame(maxWidth: .infinity, maxHeight: 58, alignment: .leading)
                                .background(.white.opacity(0.05))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .inset(by: 1.5)
                                        .stroke(.white.opacity(0.07), lineWidth: 3))
                            }
                        .frame(maxWidth: .infinity, maxHeight: 78, alignment: .topLeading)
                            
                        // Login Button     
                    Button("Login") {
                        handleLogin()
                    }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.black)
                        .padding(10)
                        .frame(maxWidth: .infinity,minHeight: 48)
                        .background(.white)
                        .cornerRadius(8)
                        .padding(.horizontal,25)
                    }
                        .frame(maxWidth: .infinity,alignment: .center)
                        .padding(.horizontal,35)
                }
                .alert("Error", isPresented: $showError) {
                    Button("OK") { showError = false }
                    } message: {
                        Text(errorMessage)
                } 
                
            } else {
                // Redirect to select account
                Text("").onAppear {
                    path.removeLast()
                    path.append(AppRoute.selectAccount)
                }
            }
        }
    }
}


#Preview {
    welcomeBack(
        path: .constant(NavigationPath()),
        selectedUsername: "Julian"
    )
}
