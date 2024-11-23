import SwiftUI

struct EditAccountView: View {
    //MARK: - un chingo de variables y el singleton
    @ObservedObject private var userManager = UserManager.shared
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var originalUsername: String = ""
    @State private var originalPassword: String = ""
    
    @State private var originalProfilePicture = ""
    @State private var isSecured: Bool = true
    
    @State private var showingImagePicker = false
    @State private var showingDeleteAlert = false
    
    @State private var selectedProfilePicture: String?
    @State private var hasChanges = false
    
    @State private var showError = false  // Missing
    @State private var errorMessage = ""  // Missing

    @Binding var path: NavigationPath

//MARK: - funciciones
    
    // propiedad computada para saber si hay cambios
    private var hasChangesComputed: Bool {
        !username.isEmpty && !password.isEmpty &&
        (username != originalUsername || 
        password != originalPassword || 
        selectedProfilePicture != originalProfilePicture)    
    }
    
    // Que cargeu los datos del usuario
        private func loadUserData() {
        // Safely unwrap current user
        guard let currentUser = userManager.currentUser else {
            // Handle error case
            showError = true
            errorMessage = "Could not load user data"
            return
        }
        
        // Load all user data
        username = currentUser.username
        password = currentUser.Password
        
        // Store original values for change detection
        originalUsername = currentUser.username
        originalPassword = currentUser.Password
        originalProfilePicture = currentUser.profilePictureName
        
        // Set profile picture
        selectedProfilePicture = currentUser.profilePictureName
        
        // Ensure UserManager data is synced
        userManager.syncUserData()
    }


// Guardar los cambios
    private func saveChanges() -> Bool {
        guard let currentUsername = userManager.currentUser?.username else {
            return false
        }

        if username != originalUsername && userManager.userExists(username) {
            showError = true
            errorMessage = "Username already exists"
            return false
        }
        
        // Create updated user data
        var updatedUser = userManager.currentUser!
        updatedUser.username = username
        updatedUser.Password = password
        
        // Update the dictionary
        userManager.userDictionary.removeValue(forKey: currentUsername)
        userManager.userDictionary[username] = updatedUser
        userManager.currentUser = updatedUser
        
        // Update profile picture if changed
        if let newProfilePic = selectedProfilePicture {
            userManager.updateProfilePictureName(to: newProfilePic)
        }
        
        // Clear navigation stack and go home
        path = NavigationPath()
        path.append(AppRoute.home)
        
        return true
    }
    
    private func deleteAccount() {
        if userManager.deleteUser(delUsername: originalUsername, delPassword: originalPassword, path: $path) {
            // Success case - navigation will be handled by UserManager
            // No need to append additional navigation
            return
        } else {
            showError = true
            errorMessage = "Failed to delete account"
        }
    }


//MARK: - Edit profile text
    var body: some View {
        VStack(alignment: .center){
            VStack(alignment: .center, spacing: 16){
                VStack(alignment: .center, spacing: 28){
                    Text("Edit profile")
                        .font(.title.bold())
                        .foregroundColor(.white)

                        //vstack para la imagen de perfil y el texto de para cambiar la contraseña
                            VStack(alignment: .center, spacing: 10){
                                Image(UserManager.shared.currentUser?.profilePictureName ?? "default_profile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                
                            //change image button    
                                HStack{
                                    Button {
                                        showingImagePicker = true
                                    } label: {
                                        HStack {
                                            Text("Change image")
                                                .font(.callout.bold())
                                            Image(systemName: "chevron.right")
                                        }
                                        .foregroundColor(.white)
                                    }
                                    .sheet(isPresented: $showingImagePicker) {
                                        selectProfilePic()
                                            .environmentObject(userManager)  // Use the existing userManager instance
                                            .onChange(of: userManager.currentUser?.profilePictureName) { newValue in
                                                if let newValue = newValue {
                                                    selectedProfilePicture = newValue
                                                    hasChanges = true
                                                }
                                            }
                                    }
                                }
                                .padding(13)
                                .frame(maxWidth: .infinity, alignment: .top)
                        
                            //MARK: - username  and password text field
                                VStack(alignment: .leading, spacing: 10){
                                    Text("Username")
                                        .font(.callout.bold())
                                        .foregroundColor(.white)
                                    HStack{
                                        TextField("Username", text: $username)
                                        Spacer()
                                        Image(systemName: "pencil")
                                            .foregroundColor(.white)
                                    }
                                    .modifier(TextFieldModifiers())
                                }
                                
                            
                                VStack(alignment: .leading, spacing: 10){
                                    Text("Password")
                                        .font(.callout.bold())
                                        .foregroundColor(.white)
                                    HStack{
                                        if isSecured {
                                            AnyView(SecureField("Password", text: $password))
                                        } else {
                                            AnyView(TextField("Password", text: $password))
                                        }
                                        Spacer()
                                        Button {
                                            isSecured.toggle()
                                        } label: {
                                            Image(systemName: isSecured ? "eye.fill" : "eye.slash.fill")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .modifier(TextFieldModifiers())
                                }
                    }
                    .padding(.horizontal, 35)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()

                //mark: - save and delete buttons
                    SaveDeleteAccountButtons(
                        hasChanges: hasChangesComputed,
                        onSave: {
                            saveChanges()
                        },
                        onDelete: {
                            showingDeleteAlert = true
                        }
                    )
                    .alert("Delete Account", isPresented: $showingDeleteAlert) {
                        Button("Delete", role: .destructive, action: deleteAccount)
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure you want to delete your account? This action cannot be undone.")
                    }
                    
                    .onAppear {
                        loadUserData()
                    }
                }
            }
        }
    }
}

//MARK: - save and delete buttons
struct SaveDeleteAccountButtons: View{

    var hasChanges: Bool
    public let onSave: () -> Void
    public let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 26){
            Button {
                onSave()
            } label: {
                Text("Save")
                    .padding(10)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(hasChanges ? .black : .white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(hasChanges ? .white : .white.opacity(0.5) )
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 1.5)
                            .stroke( hasChanges ? . white.opacity(0) : .white.opacity(0.07), lineWidth: 3)
                    )
            }
            .disabled(!hasChanges)

            Button {
                onDelete()
            } label: {
                Text("Delete Account")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.red)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 48)
            
            }
        }
        .padding(.horizontal, 41)
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

//MARK: - text field modifiers
struct TextFieldModifiers: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.04))
            .cornerRadius(3)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .inset(by: 1)
                    .stroke(.white.opacity(0.13), lineWidth: 2)
            )
    }
}

#Preview {
    EditAccountView(path: .constant(NavigationPath()))
}
