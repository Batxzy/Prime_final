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
    
    @State private var showError = false  
    @State private var errorMessage = "" 

    //hay un state  que controla la navegacion por stacks
    @Binding var path: NavigationPath

//MARK: - funciciones
    
    // propiedad computada para saber si hay cambios
    private var hasChangesComputed: Bool {
        !username.isEmpty && !password.isEmpty &&
        (username != originalUsername || 
        password != originalPassword || 
        selectedProfilePicture != originalProfilePicture)    
    }
    
    // funcion para que cargue los datos del usario
        private func loadUserData() {
        
            
        // use unguard para poder manejar el caso de que que el current user. bascimenete si no existe un usuario para nadota y trato de cargar datos
        
        //current user esta en el user model  y guarda la informacion del usario actual
            
        guard let currentUser = userManager.currentUser else {
            showError = true
            errorMessage = "Could not load user data"
            return
        }
        
        
        username = currentUser.username
        password = currentUser.Password
        
        
        //guardo en memoria la imagen original y el pfp original y el selecionado para poder hacer cambios depues
            
        originalUsername = currentUser.username
        originalPassword = currentUser.Password
        
        originalProfilePicture = currentUser.profilePictureName
        selectedProfilePicture = currentUser.profilePictureName
        
       
        userManager.syncUserData()
    }


// Guardar los cambios
    private func saveChanges() -> Bool {
        
        // cuando no exsite un usario en el user manager y este da nil valio madres y la funcion save changes va retornar falso lol
        
        //tipo ahi lo que anda haciendo es crear una variable que solo va ser usada en la funcion. asi k si accedo al user manager y no existe un current user la fakin shit va dar nil si da nil va retornar que es falso
        
        guard let currentUsername = userManager.currentUser?.username else {
            return false
        }

        //si es exitoso, va checcar primero que tu usuario no sea el mismo que ya tenias y hacer una funcion en el user manager que va checha y va decir. " a chinga este usario ya existe en el prime de este cel, nell perro"
        
        if username != originalUsername && userManager.userExists(username) {
            //esto dispara un mensaje de error que es definido mas abaajo
            showError = true
            errorMessage = "Username already exists"
            return false
        }
        
        
        // si todo bien y todo correcto primero guardo el  el current user en un una variable y actualizo los valores de este im not sure this does something lol
        
        
        var updatedUser = userManager.currentUser!
        updatedUser.username = username
        updatedUser.Password = password
        
        
        userManager.userDictionary.removeValue(forKey: currentUsername)
        userManager.userDictionary[username] = updatedUser
        userManager.currentUser = updatedUser
        
        
        
        if let newProfilePic = selectedProfilePicture {
            userManager.updateProfilePictureName(to: newProfilePic)
        }
        
        
        path = NavigationPath()
        path.append(AppRoute.home)
        
        return true
    }
    
    private func deleteAccount() {
        if userManager.deleteUser(delUsername: originalUsername, delPassword: originalPassword, path: $path) {
            return
        } else {
            showError = true
            errorMessage = "Failed to delete account"
        }
    }


//MARK: - Edit profile text
    var body: some View {
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
                                //cuando le puchas al boton cambias la state variable
                                showingImagePicker = true
                            } label: {
                                HStack {
                                    Text("Change image")
                                        .font(.callout.bold())
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.white)
                            }
                            
                            //usando una sheet para presentar el selecionador de imagenes de perfil
                            
                            //esta madre ocupa una state variable para controlar si se ve o ne
                            .sheet(isPresented: $showingImagePicker) {
                                
                                //llamo a la view de selecionar imagenes de perfil
                                selectProfilePic()
                                
                                //tengo que usar el protocolo enviorment object, para poder acceder a la informacion que esta adentro de user manager siendo este la clase que hay detras
                                
                            //NOTA: no se si esto sirva, prolly necesito chechar el codigo
                                    .environmentObject(userManager)
                                
                                //NOTA: lo mismo aca en teoria checha si hubo algun cambio
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
