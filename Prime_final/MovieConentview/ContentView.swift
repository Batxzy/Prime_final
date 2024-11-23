//
//  ContentView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI
import AVKit

// MARK: - POSTER
struct posterview: View {
    let imageUrl: String
    var body: some View {
        ZStack {
            Image(imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 221)
                .clipped()
            // Gradient
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .black.opacity(0), location: 0.00),
                    Gradient.Stop(color: Color(red: 0, green: 0.02, blue: 0.05), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: 221)
        .foregroundColor(.clear)
    }
}

//MARK: - BUTTON AND TITLE
struct buttontitle: View {
    
    let Movietitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Title
            Text(Movietitle)
                .font(.title.bold())// Allows for two lines before truncating
                .fixedSize(horizontal: false, vertical: true) // Allows text to wrap
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Button
            NavigationLink(destination: VideoPlayerView(VideoUrl:"")) {
                HStack(alignment: .center, spacing: 10) {
                    Image("PlayButton")
                    Text("play")
                        .font(.headline.bold())
                        .kerning(0.56)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(.white)
                .cornerRadius(10)
            }
        }
        .padding(0) // Add horizontal padding
    }
}

struct VideoPlayerView: View {
    let VideoUrl :String
    var body: some View {
        let url = URL(string: "https://your-video-url.com")!
        VideoPlayer(player: AVPlayer(url: url))
            .edgesIgnoringSafeArea(.all)
    }
}

//MARK: -INTERACTIVE VIEW
struct interactiveView: View{
    let movieId: Int
    @EnvironmentObject var userManager : UserManager


    // Computed properties to get current state
         var isInWatchlist: Bool {
            userManager.currentUser?.watchlist.contains(movieId) ?? false
        }
        
         var isLiked: Bool {
            userManager.currentUser?.likedMovies.contains(movieId) ?? false
        }
        
         var isDisliked: Bool {
            userManager.currentUser?.dislikedMovies.contains(movieId) ?? false
        }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 20) {
            //watchlist
            VStack(alignment: .center, spacing: 10) {
                Button(action: {
                       userManager.toggleWatchlist(movieId: movieId)
                }) {
                    VStack(alignment: .center) {
                        Image(systemName: isInWatchlist ? "plus.app.fill" : "plus.app" )
                            .resizable()
                            .foregroundStyle(.white)
                    }
                    .frame(width: 25, height: 25, alignment: .center)
                }
                
                Text("Watchlist")
                    .padding(6)
                    .font(.callout.bold()).multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(alignment: .center)
                
            }
            .padding(0)
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack(alignment: .center, spacing: 10) {
                Button(action: {
                    userManager.toggleLike(movieId: movieId)
                }) {
                    VStack(alignment: .center) {
                        Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                        
                            .resizable()
                            .foregroundStyle(.white)
                    }
                    .frame(width: 25, height: 25, alignment: .center)
                }
                
                Text("Like")
                    .padding(6)
                    .font(.callout.bold()).multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(alignment: .center)
                
            }
            .padding(0)
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack(alignment: .center, spacing: 10) {
                Button(action: {
                    userManager.toggleDislike(movieId: movieId)
                }) {
                    VStack(alignment: .center) {
                        Image(systemName: isDisliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .resizable()
                            .foregroundStyle(.white)
                    }
                    .frame(width: 25, height: 25, alignment: .center)
                }
                
                Text("Dislike")
                    .padding(6)
                    .font(.callout.bold()).multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(alignment: .center)
                
            }
            .padding(0)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        
        .padding(.horizontal, 0)
        .padding(.top, 10)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, minHeight: 75, maxHeight: 75, alignment: .center)
    }
}

//MARK: -INFOVIEW

struct infoView: View {
    let description: String
    let genres: [String]
    let subgenres: [String]
    let rating: Double
    let year: String
    let duration: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(description).font(.footnote.bold())
            
            VStack(alignment: .leading, spacing: 10) {
                Text(genres.joined(separator: " • "))
                    .font(.footnote.bold())
                Text(subgenres.joined(separator: " • "))
                    .font(.footnote.bold())
            }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            VStack(alignment: .leading, spacing: 5){
                Text("IMDB \(rating)")
                    .font(.footnote.bold())
                    .foregroundColor(.white.opacity(0.50))
                
                HStack(alignment: .center, spacing: 8){
                    Text(year)
                    .font(.footnote.bold())
                    .foregroundColor(.white.opacity(0.50))
                    Text(duration)
                    .font(.footnote.bold())
                    .foregroundColor(.white.opacity(0.50))
                }
            }
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

//MARK: -MAIN VIEW
struct ContentView2: View {
    @Binding var path: NavigationPath
    let CurrentmovieId: Int
    @StateObject private var movieDB = MovieDatabase.shared
    @EnvironmentObject private var userManager : UserManager
    
    var body: some View {
                VStack(alignment:.leading, spacing: 0) {
                    //imagen
                    posterview(imageUrl:movieDB.movies[CurrentmovieId].thumbnailHUrl)
                    //stack del boton y la info
                    VStack(alignment: .leading, spacing: 11) {
                        //titulo y boton
                        buttontitle(Movietitle: movieDB.movies[CurrentmovieId].title)
                        //fin del titulo y boton
                        interactiveView(movieId: CurrentmovieId)
                        // inico de los botones de interracion
                        infoView(
                            description: movieDB.movies[CurrentmovieId].description,
                            genres: movieDB.movies[CurrentmovieId].genres,
                            subgenres: movieDB.movies[CurrentmovieId].subgeneres,
                            rating: movieDB.movies[CurrentmovieId].rating,
                            year: movieDB.movies[CurrentmovieId].year,
                            duration:movieDB.movies[CurrentmovieId].duration)
                    }
                    .padding(.horizontal, 25)
                    .frame(maxWidth: .infinity, maxHeight:, .infinity alignment: .top)
                }
    }
}

#Preview {
    ContentView2(
        path: .constant(NavigationPath()),
        CurrentmovieId: 4
    )
    .environmentObject(UserManager())
}
