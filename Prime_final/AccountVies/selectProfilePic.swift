import SwiftUI

//MARK: - Select pfp view 
struct selectProfilePic: View {
@EnvironmentObject var userManager: UserManager
@Environment(\.dismiss) var dismiss

private let categories = profilePictureCategories

    var body: some View {
        VStack(alignment: .center){
            Text("Change Profile Picture")
                .padding(16)
                .font(.system(size: 23,weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity) 
            profilePictureViews()
        }
        .preferredColorScheme(.dark)
    }
        
}

//MARK: - profilePictureViews
struct profilePictureViews: View {
    @EnvironmentObject var userManager: UserManager
    
    let categories = profilePictureCategories

    var body: some View {
        ScrollView(.vertical){
            LazyVStack (spacing: 36){
                    ForEach(categories, id:\.name) { category in
                        VStack(alignment: . leading, spacing: 14){
                            Text(category.name)
                                .font(.system(size: 16,weight: .black))
                                .foregroundColor(.white)

                            ScrollView(.horizontal,showsIndicators: false){
                                LazyHStack(spacing: 13){
                                ForEach(category.images, id: \.self) { imageName in
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .modifier(profileCircle(isSelected: userManager.currentUser?.profilePictureName == imageName))
                                        .onTapGesture {
                                            userManager.updateProfilePictureName(to: imageName)
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 25) 
    }
}

struct profileCircle: ViewModifier {
    var isSelected: Bool
    func body(content: Content) -> some View {
        content
            .background(.white.opacity(0.05))
            .clipShape(Circle())
            .frame(width: 91, height: 91)
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
            )
    }
}

#Preview {
    selectProfilePic()
            .environmentObject(UserManager())
}
