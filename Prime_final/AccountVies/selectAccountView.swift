
import SwiftUI

struct SelectAccountView: View {

    @Binding var path: NavigationPath
    @State private var isEditing = false
    @EnvironmentObject private var userManager : UserManager

    var body: some View {
        //MARK: - main view
        VStack(alignment:.leading, spacing:15){ 
            VStack(alignment: .leading) {
                Text("Who's Watching?")
                    .font(.system(size: 25, weight: .black))
                    .foregroundColor(.white)
            }
                .padding(27)
                .frame(maxWidth:.infinity,alignment:.bottom)

            ProfileGridView(isEditing: $isEditing, path: $path)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            BottomEditView(isEditing: $isEditing)
        }
            .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading)
            .onAppear {
                print("Current users: \(userManager.userDictionary)")
            }
    }
}

//MARK: - Profile Button
struct ProfileButton: View {
    
    var profileName: String
    var PFPimage: String
    @Binding var isEditing: Bool
    @Binding var path: NavigationPath
    @EnvironmentObject private var userManager : UserManager
    
    var body: some View{
            VStack(alignment:.center,spacing:13) {
                ZStack {
                    Image(PFPimage)
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                       .frame(width: 85, height: 85)
                       .clipShape(Circle())
                               
                       if isEditing {
                           Circle()
                               .fill(Color.black.opacity(0.6))
                               .frame(width: 85, height: 85)
                           
                           Image(systemName: "pencil")
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
            if isEditing {
                if userManager.currentUser?.username == profileName {
                    path.append(AppRoute.editProfile)
                } else {
                    userManager.syncUserData()
                    userManager.currentUser = userManager.userDictionary[profileName]
                    path.append(AppRoute.welcomeBack(profileName))
                }
            } else {
                if userManager.currentUser?.username == profileName {
                    path.append(AppRoute.home)
                } else {
                    userManager.syncUserData()
                    userManager.switchToUser(username: profileName, path: $path)
                }
            }
        }
    }
}

//MARK: - Add Profile Button
struct AddProfileButton: View {
    @EnvironmentObject private var userManager : UserManager
    @Binding var path: NavigationPath
    var body: some View {
        Button(action: {
            userManager.backButtonlogin = false
            path.append(AppRoute.login)

        }) {
            VStack(alignment: .center, spacing: 13) {
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
    @Binding var path: NavigationPath

    @EnvironmentObject private var userManager : UserManager

    //definicion de las columnas
    let columns = Array(repeating: GridItem(.flexible(),spacing: 55), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns:columns, spacing: 20) {
                
                ForEach(Array(userManager.userDictionary.values), id: \.username) { user in
                    
                    ProfileButton(profileName: user.username,
                                PFPimage: user.profilePictureName, 
                                isEditing: $isEditing,
                                path: $path)
                    }
                AddProfileButton(path: $path).opacity(isEditing ? 0.3 : 1)
            }
            .padding(.horizontal,51)
        }
    }
}


//MARK: - edit profile, learn more
struct BottomEditView: View {
    @EnvironmentObject private var userManager : UserManager
    @Binding var isEditing: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            Button {
                isEditing.toggle()
            } label: {
                Text(isEditing ? "Done" : "Edit Profile")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(isEditing ? .black : .white)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(isEditing ? Color.white : .white.opacity(0.2))
            .cornerRadius(8)
        }
        .padding(.horizontal, 41)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}


#Preview {
    SelectAccountView(path: .constant(NavigationPath()))
}
