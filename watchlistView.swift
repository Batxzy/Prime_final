import SwiftUI

struct watchlistView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss

    @State private var showEmptyState = false

    var watchlistCount: Int {
        userManager.currentUser?.watchlist.count ?? 0
    }

    var body: some View {
        VStack(alignment: .center){
            //watchlist y su count
            VStack {
                VStack(alignment:.center){
                    Text("Watchlist")
                        .font(.system(size: 16,weight: .black))
                        .foregroundColor(.white)
                        .frame(maxHeight: . infinity)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity, minHeight: 3, maxHeight: 3)
                        .background(Constants.BackgroundsPrimary)
                        .opacity(watchlistCount == 0 ? 0 : 1)

                }
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: 50)

                VStack(alignment:.leading){
                    Text("\(watchlistCount) videos")
                    .font(.system(size: 16,weight: .black))
                    .foregroundColor(.white)
                }
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .top)
            .ignoresSafeArea()

            if watchlistCount == 0 {
            Text("Your watchlist is empty")
                .foregroundColor(.gray)
                .padding(.top, 40)
                .frame(maxWidth: .infinity, alignment: .center, maxHeight: .infinity)
            } 
            
            else {
            ListWatchable()
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }
}



struct ListWatchable: View{

    @EnvironmentObject var userManager: UserManager
    let movieDB = MovieDatabase.shared
   
    var watchlistMovies: [MovieData] {
        guard let currentUser = userManager.currentUser else { return [] }
        return movieDB.movies.filter { currentUser.watchlist.contains($0.id) }
    }

    var body some View{
        LazyVStack(spacing: 16) {
            ForEach(watchlistMovies) { movie in
                watchChip(movie: movie)
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.horizontal, 25)
        .padding(.vertical, 20)
    }
}

struct watchChip: View{
    let movie: MovieData

    var body some View{
        NavigationLink(destination: ContentView2(CurrentmovieId: movie.id)) {
            HStack(alignment: .top, spacing: 8){
                Image(movie.thumbnailHUrl)
                .resizable()
                .aspectRatio(16/9,contentMode: .fill)
                .frame(width: 146, height: 86)
                .cornerRadius(6)
                .clipped()

                VStack(alignment: .leading, spacing: 8){
                    
                    Text(movie.title)
                    .font(.system(size: 14,weight: .bold))
                    .foregroundColor(.white)

                    HStack(spacing:8){
                        Text(movie.year)
                        .font(.system(size: 14,weight: .bold))
                        .kerning(0.56)
                        .foregroundColor(Color(red: 0.59, green: 0.6, blue: 0.61))

                        Text(movie.duration)
                        .font(.system(size: 14,weight: .bold))
                        .kerning(0.56)
                        .foregroundColor(Color(red: 0.59, green: 0.6, blue: 0.61))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                Button(action: {    
                    //TODO: model sheet view
                        })
                {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}