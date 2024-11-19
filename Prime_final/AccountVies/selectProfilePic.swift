import SwiftUI

//MARK: - Select pfp view 
struct selectProfilePic: View {
@EnvironmentObject var navigationManager: NavigationManager
@EnvironmentObject var userManager: UserManager
@Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .center){
            Text("Change Profile Picture")
                .padding(16)
                .font(.system(size: 16,weight: .black))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity) 
            profilePictureViews()
        }
    }
}

//MARK: - profilePictureViews
struct profilePictureViews: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userManager: UserManager
    let categories = profilePictureCategories

    var body: some View {
        ScrollView(.horizontal){
            LazyHStack (spacing: 36){
                    ForEach(categories, id:\.name) { category in 
                        VStack(alignment: . leading, spacing: 14){
                            Text(category.name)
                                .font(.system(size: 16,weight: .black))
                                .foregroundColor(.white)

                            ScrollView(.horizontal,showsIndicators: false){
                                LazyHStack(spacing: 10){
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
@EnvironmentObject var navigationManager: NavigationManager
    selectProfilePic()
}
