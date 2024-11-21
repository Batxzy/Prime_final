import SwiftUI


struct Settings: View {
    @Binding var path: NavigationPath
    @State private var search = ""
    
    var body: some View {
        HStack(alignment: .top){

            VStack(spacing: 24){
                
                TextField("Enter your text here", text: $search)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        Spacer()
                    }
                )
                .padding(.leading, 24)
            //genres
                VStack(alignment:.leading, spacing; 10){
                    text(genres)
                        .font(.system(size: 25, weight: .black))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 33 alignment: .leading)
                    
                //generes chips
                        VStack(spacing: 13) {
                            VStack(spacing: 14){
                                genre(name: "Action and adventure")
                                genre(name: "Comedy")  
                            }

                            VStack(spacing: 14){
                                genre(name: "Anime")
                                genre(name: "Comedy")  
                            }

                            VStack(spacing: 14){
                                genre(name: "Drama")
                                genre(name: "Fantasy")  
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)

                    Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 40)
                    .overlay(
                        Text("See More")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    )
                }
            }
                .padding(.horizontal, 25)
                .padding(.top, 125)
    }
}

struct Chipmovies: View {
    var genre: String

    var body: some View {
        Text(genre)
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .padding(13)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
            .frame(maxWidth: .infinity, maxWidth: .infinity)
    }
}