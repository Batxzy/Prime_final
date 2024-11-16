import SwiftUI

struct welcomeBack: View {
    @StateObject private var userManager = UserManager.shared
    let selectedUsername: String  
    @State private var password: String = ""
    @State private var isSecured: Bool = true
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    private func handleLogin() {
        guard userManager.login(username: selectedUsername, password: password) else {
            showError = true
            errorMessage = "Invalid password"
            return
        }
        // Login successful
        password = ""
        if userManager.navigateToEditProfileAfterWelcomeBack {
            userManager.currentScreen = .editProfile
            userManager.navigateToEditProfileAfterWelcomeBack = false
        }
    }

    var body: some View {
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
                    Circle()
                    .foregroundColor(.white)
                    .frame(width:85, height:85)
                    .background(
                        Image(userManager.userDictionary[selectedUsername]?.profilePictureName ?? "profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                    )
                }
            }   
            VStack(alignment: .center, spacing: 25) {                  
                // Password
                VStack(alignment: .leading,spacing: 10){

                        Text("Password")
                        .font(.callout.bold()).foregroundColor(.white)

                        HStack {
                            (isSecured ? SecureField("Password", text: $password) : TextField("Password", text: $password))
                                .preferredColorScheme(.dark)
                                .frame(maxWidth: .infinity, minHeight: 58)
                            
                            Spacer()
                            
                            Button { isSecured.toggle() }  {
                                Image(systemName: isSecured ? "eye.fill" : "eye.slash.fill")
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 1.5)
                                .stroke(.white.opacity(0.07), lineWidth: 3)
                        )
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
        }
    }
}

#Preview {
    welcomeBack(selectedUsername: "defaultUsername")
}
