
import SwiftUI

struct SelectAccountView: View {
@State private var isEditing = false
var body: some View {
//MARK: - main view
        VStack(alignment:.leading, spacing:15){ 
            VStack(alignment: .bottom) {
                Text("Who's Watching?")
                    .font(.system(size: 25, weight: .black))
                    .foregroundColor(.white)
            }
            .padding(27)
            .frame(maxWidth:.infinity,alignment:.bottom)
            
            ProfileGridView().opacity(isEditing ? 0 : 1)
            .frame(maxHeight: .infinity ,maxWidth: .infinity)
            BottomEditView(isEditing: $isEditing)
         }
            .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading)
     }
}

//MARK: - Profile Button
struct ProfileButton: View {
    var profileName: String
    var PFPimage: String
    @Binding var isEditing: Bool
    @StateObject private var userManager = UserManager.shared
    
    var body: some View{
            VStack(alignment:.center,spacing:5) {
            ZStack{
            Image(PFPimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 85, height: 85)
                    .clipShape(Circle())
                    .opacity(isEditing ? 0.5 : 1.0)

                if isEditing {
                        Image(systemName: "pencil.circle.fill") // or your custom pen image
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
            }
                Text(profileName)
                    .font(.system(size: 15,weight: .black))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 88 ,maxHeight: 133, alignment: .top)
            .onTapGesture {
            if userManager.currentUser?.username == profileName {
                userManager.currentScreen = .editAccount // Navigate to edit account view
            } else {
                userManager.currentUser = userManager.userDictionary[profileName]
                userManager.currentScreen = .welcomeBack
            }
        }
    }
}

//MARK: - Add Profile Button
struct AddProfileButton: View {
    @StateObject private var userManager = UserManager.shared
    var body: some View {
        Button(action: {
            userManager.currentScreen = .createAccount
        }) {
            VStack(alignment: .center, spacing: 5) {
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 85, height: 85)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    )
                
                Text("Add Profile")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 88,maxHeight: 133, alignment: .top)
        }
    }
}

//MARK: - Proflie Grid View
struct ProfileGridView: View {
    @Binding var isEditing : Bool
    //imporatar el objeto que controla los usuarios
    @StateObject private var userManager = UserManager.shared

    //definicion de las columnas
    let columns = Array(repeating: GridItem(.flexible(),spacing: 55), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns:columns, spacing: 20) {
                ForEach(Array(userManager.userDictionary.values), id: \.username) { user in 
                    ProfileButton(profileName: user.username, PFPimage: user.profilePictureName, isEditing: $isEditing)
                    }
                AddProfileButton().opacity(isEditing ? 0 : 1)
            }
            .padding(.horizontal:51)
        }
    }
}


//MARK: - edit profile, learn more
struct BottomEditView: View {
    @StateObject private var userManager = UserManager.shared 
    @Binding var isEditing: Bool
    var body: some View {

    //done y editar button
        VStack(alignment:.leading,spacing:26){
            Button(action: {
                isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit Profile")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(isEditing ? .black : .white)
                }
            .padding(.horizontal, 10)
            .frame(maxWidth:.infinity, minHeight: 48)
            .background(isEditing ? Color.white : .white.opacity(0.2))
            .cornerRadius(8)

        }
        .padding(.horizontal, 41)
        .frame(maxWidth:.infinity,alignment:.topLeading)
    }
}


#Preview {
    SelectAccountView()
}