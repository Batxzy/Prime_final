import SwiftUI

struct selectProfilePic: View {

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var originalUsername: String = ""
    @State private var originalPassword: String = ""
    @State private var isSecured: Bool = true
    @State private var isSaving: Bool = false

  private var hasChanges: Bool {
        username != originalUsername || password != originalPassword
    }

    var body: some View {
        VStack(alignment: .center){
            VStack(alignment: .center, spacing: 16){
                // Change Profile Picture
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
                                // Navigation action will be added later
                            } label: {
                                HStack {
                                    Text("Change image")
                                        .font(.callout.bold())
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(13)
                .frame(maxWidth: .infinity, alignment: .top)

                // Username text field
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

                // password text field
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

            SaveDeleteAccountButtons(hasChanges: hasChanges)           
        }
    }
}



struct SavedeleteAccountButttons: View{
@Binding var hasChanges: Bool  
    var body: some View{
        VStack(alignment: .center, spacing: 26){
            Button {
                // Save action will be added later
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
                // Delete action will be added later
            } label: {
                Text("Delete Account")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.red)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 48)
            
            }
        }
        .padding(.horizontal, 45)
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

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