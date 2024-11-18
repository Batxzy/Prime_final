import SwiftUI

//MARK: - watchlistView
struct watchlistView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var navigationManager: NavigationManager 
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

//MARK: - ListWatchable
struct ListWatchable: View{
    @EnvironmentObject var userManager: UserManager
    let movieDB = MovieDatabase.shared
   
    var watchlistMovies: [MovieData] {
        guard let currentUser = userManager.currentUser else { return [] }
        return movieDB.movies.filter { currentUser.watchlist.contains($0.id) }
    }

    var body: some View{
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

//MARK: - watchChip
struct watchChip: View{
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var showingActionSheet = false
    @EnvironmentObject var userManager: UserManager
    let movie: MovieData

    var body some View{
        Button {
            navigationManager.navigate(to: .movieDetail(movie.id))
             } {
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
                    
                Button(action: {showingActionSheet = true}) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showingActionSheet) {
                        ModalSheetView(movie: movie, isPresented: $showingActionSheet)
                        .presentationDetents([.height(300)])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.ultraThinMaterial)
                        .presentationCornerRadius(12)

                    }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

//MARK: - ModalSheetView
struct ModalSheetView: View {
    let movie: MovieData
    @Binding var isPresented: Bool
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(alignment: .center){

            HStack(alignment: .center, spacing: 10) { 
                Text(movie.title)
                    .font(.system(size: 16,weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            
                Spacer()
                
                Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .center)

            divider()

            VStack(alignment: .leading, spacing: 13) { 
                Button(action: {
                    userManager.removeFromWatchlist(movieId: movie.id)
                    isPresented = false
                     }) {
                    HStack (alignment: .center, spacing: 15) {
                        Image(systemName: "minus.circle")
                        Text("Remove from Watchlist")
                            .foregroundColor(.white)
                            .font(.system(size: 16,weight: .bold))

                    }
                    .frame(maxWidth: .infinity)
                }
                
                Button(action: {
                    isPresented = false
                    navigationManager.navigate(to: .movieDetail(movie.id))
                    }) {
                    HStack (alignment: .center, spacing: 15) {
                        Image(systemName: "info.circle")
                        Text("View Details")
                            .foregroundColor(.white)
                            .font(.system(size: 16,weight: .bold))
                }
            }
        }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(color.black)
    }
}
