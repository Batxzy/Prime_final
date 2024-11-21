import SwiftUI


struct Settings: View {
    @Binding var path: NavigationPath
    @State private var search = ""
    
    var body: some View {
        HStack(alignment: .top){

            VStack(spacing: 24){
                
                TextField("Search by actor, title", text: $search)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 53)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            Spacer()
                        }
                    )
            //genres
                VStack(alignment:.leading, spacing: 10){
                    Text("Genres")
                        .font(.system(size: 25, weight: .black))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 33, alignment: .leading)
                    
            //generes chips
                        VStack(spacing: 13) {
                            VStack(spacing: 14){
                                GenreChip(genreName: "Action and adventure")
                                GenreChip(genreName: "Anime")  
                            }

                            VStack(spacing: 14){
                                GenreChip(genreName: "Comedy")
                                GenreChip(genreName: "Documentary")  
                            }

                            VStack(spacing: 14){
                                GenreChip(genreName: "Drama")
                                GenreChip(genreName: "Fantasy")  
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

struct GenreChip: View {
    var genreName: String

    var body: some View {
        Text(genreName)
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .padding(13)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
    }
}