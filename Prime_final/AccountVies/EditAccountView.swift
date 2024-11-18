import SwiftUI

struct EditAccountView: View {
//MARK: - un chingo de variables y el singleton
    @ObservedObject private var userManager = UserManager.shared
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var originalUsername: String = ""
    @State private var originalPassword: String = ""
    @State private var isSecured: Bool = true
    @State private var showingImagePicker = false
    @State private var showingDeleteAlert = false
    @State private var selectedProfilePicture: String?

//MARK:- funciciones

    // propiedad computada para saber si hay cambios
  private var hasChanges: Bool {
        username != originalUsername || password != originalPassword
    }

    // Que cargeu los datos del usuario
    private func loadUserData() {
        if let currentUser = userManager.currentUser {
            username = currentUser.username
            password = currentUser.Password
            originalUsername = currentUser.username 
            originalPassword = currentUser.Password
        }
    }
    
    // Guardar los cambios
    private func saveChanges() {
        guard let currentUser = userManager.currentUser else { return }
        
        // CHECAR SI EL USUARIO YA EXISTE
        if username != originalUsername || password != originalPassword {
            //Actualizar el usuario
            currentUser.username = username
            currentUser.Password = password
        }
        
        // Update profile picture
        if let newProfilePic = selectedProfilePicture {
            _ = userManager.updateProfilePictureName(to: newProfilePic)
        }
        
        userManager.currentScreen = .home
    }

    // delete functionality 
    private func deleteAccount() {
        if userManager.deleteUser(delUsername: originalUsername, delPassword: originalPassword) {
            userManager.currentScreen = .selectUser
        }
    }

    var body: some View {
        VStack(alignment: .center){
            VStack(alignment: .center, spacing: 16){
//MARK: - Edit profile text
                VStack(alignment: .center, spacing: 28){
                    Text("Edit profile")
                        .font(.title.bold())
                        .foregroundColor(.white)

                    VStack(alignment: .center, spacing: 10){
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(
                                Image("profile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                            )
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
                                ProfilePicturePickerView()
                        }
                    }
                }
                .padding(13)
                .frame(maxWidth: .infinity, alignment: .top)

//MARK: - username text field
                VStack(alignment: .center, spacing: 10){
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

//MARK: - password text field
                VStack(alignment: .center, spacing: 10){
                    Text("Password")
                        .font(.callout.bold())
                        .foregroundColor(.white)
                    HStack{
                        (isSecured ? SecureField("Password", text: $password) : TextField("Password", text: $password))
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

            SaveDeleteAccountButtons(
                hasChanges: hasChanges,
                    onSave: {
                        saveChanges()
                        hasChanges = false
                    },
                    onDelete: { 
                        showingDeleteAlert = true }
                    )
                    .alert("Delete Account", isPresented: $showingDeleteAlert) {
                        Button("Delete", role: .destructive, action: deleteAccount)
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure you want to delete your account? This action cannot be undone.")
                    }         
        }

        .onAppear {
            loadUserData()
        }
    }
}
}

//MARK: - save and delete buttons
struct SaveDeleteAccountButtons: View{

let hasChanges: Bool
let onSave: () -> Void
let onDelete: () -> Void

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