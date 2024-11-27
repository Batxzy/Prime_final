import SwiftUI

//MARK: - watchlistView
struct watchlistView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    @State private var showEmptyState = false

    var watchlistCount: Int {
        userManager.currentUser?.watchlist.count ?? 0
    }

    var body: some View {
        VStack{
            
            watchlistTitle()
            
            if watchlistCount == 0 {
                
                VStack {
                    Image(systemName: "xmark.bin")
                        .font(.title)
                        .foregroundStyle(.gray)
                    
                    Text("Your watchlist is empty")
                            .font(.callout.weight(.medium))
                        .foregroundColor(.gray)
                        .padding(.top, 15)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } 
            
            else {
                
                ListWatchable(path: $path)
                .frame(maxWidth: .infinity, alignment: .top)
                
            }
        }
        .padding(.top, 45)
    }
}

//MARK: - ListWatchable
struct ListWatchable: View{
    @Binding var path: NavigationPath
    @EnvironmentObject var userManager: UserManager
    let movieDB = MovieDatabase.shared
   
    var watchlistMovies: [MovieData] {
        guard let currentUser = userManager.currentUser else { return [] }
        return movieDB.movies.filter { currentUser.watchlist.contains($0.id) }
    }

    var body: some View{
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                ForEach(watchlistMovies) { movie in
                    watchChip(path: $path, movie: movie)
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
        }
    }
}

//MARK: - watchChip
struct watchChip: View{
    @State private var showingActionSheet = false
    @EnvironmentObject var userManager: UserManager
    @Binding var path: NavigationPath
    
    let movie: MovieData
    var body: some View {
        
        Button(action: {
            path.append(AppRoute.movieDetail(movie.id))
        }) {
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
                        .multilineTextAlignment(.leading)
                    
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
                        .frame(maxHeight: 17)
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.white)
                        
                }
                .sheet(isPresented: $showingActionSheet) {
                    ModalSheetView(movie: movie, isPresented: $showingActionSheet, path: $path)
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
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading){

            HStack() {
                Text(movie.title)
                    .font(.system(.title,weight: .bold))
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
                .padding(.top, 24)
                .frame(maxWidth: .infinity, alignment: .center)


            VStack(alignment: .leading, spacing: 15) {
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
                }
                
                Button(action: {
                    isPresented = false
                    path.append(AppRoute.movieDetail(movie.id))
                    
                    }) {
                    HStack (alignment: .center, spacing: 15) {
                        Image(systemName: "info.circle")
                        Text("View Details")
                            .foregroundColor(.white)
                            .font(.system(size: 16,weight: .bold))
                }
            }
        }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}
//MARK: - Ttitle
struct watchlistTitle: View {
    
    @EnvironmentObject var userManager: UserManager
    
    var watchlistCount: Int {
        userManager.currentUser?.watchlist.count ?? 0
    }
    
    var body: some View {
        VStack(alignment: .center){
            Text("Watchlist")
                .frame(maxWidth: .infinity, maxHeight: 50,alignment: .top)
                .font(.system(size: 28,weight: .bold))
                .foregroundColor(.white)
                
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, minHeight: 3, maxHeight: 3)
                .background(.white)
            
            VStack(alignment:.leading){
                Text("\(watchlistCount) videos")
                    .font(.system(size: 16,weight: .black))
                    .foregroundColor(.white)
            }
            .padding(12)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity,alignment: .leading)
            
        }
        .padding(.vertical, 10)
        .padding(.top,20)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(.white.opacity(0.15))
    }
}

#Preview {
    let mockUserManager = UserManager.shared
    
    //mock user
    let mockUser = UserBlueprint(
        username: "TestUser",
        profilePictureName: "default_profile",
        likedMovies: [],
        dislikedMovies: [],
        watchlist: [0, 1, 2], 
        Password: "test123"
    )
    
    
    mockUserManager.userDictionary["TestUser"] = mockUser
    mockUserManager.currentUser = mockUser
    
    return watchlistView(path: .constant(NavigationPath()))
        .environmentObject(mockUserManager)
}
