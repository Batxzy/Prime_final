import SwiftUI

struct selectProfilePic: View {
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

struct profilePictureViews: View {

let categories = profilePictureCategories

    var body: some View {
        ScrollView(.horizontal){
            lazyHstack(spacing: 36){
                    ForEach(categories, id:\.name ){ category in 
                        VStack(alignment: . leading, spacing: 14){
                            text(category.name)
                                .font(.system(size: 16,weight: .black))
                                .foregroundColor(.white)

                            ScrollView(.horizontal,showsIndicators: false){
                                lazyHstack(spacing: 10){
                                ForEach(category.images, id: \.self){ imageName in
                                    image()
                                        .resizable()
                                        .scaleToFill()
                                        .modifier(profileCircle())
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

struct profileCircle: ViewModifier{
    func body(content: Content) -> some View{
        content
            .background(.white.opacity(0.05))
            .clipShape(Circle())
            .frame(width: 91, height: 91)
    }
}
