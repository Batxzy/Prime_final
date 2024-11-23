//
//  categoryScroll.swift
//  Prime_final
//
//  Created by lian on 23/11/24.
//

import SwiftUI


// Genre-based scroll view
struct CategoryScroll: View {
    @StateObject private var movieDB = MovieDatabase.shared
    @Binding var path: NavigationPath
    let category: MovieCategory
    let title: String
    
    // Filter movies based on category
    var filteredMovies: [MovieData] {
        switch category {
        case .action:
            return movieDB.movies.filter { $0.genres.contains("Action") }
        case .animation:
            return movieDB.movies.filter { $0.genres.contains("Animation") }
        case .drama:
            return movieDB.movies.filter { $0.genres.contains("Drama") }
        case .sciFi:
            return movieDB.movies.filter { $0.genres.contains("Sci-Fi") }
        case .trending:
            return movieDB.movies.filter { $0.rating >= 8.0 }
        case .random:
            return Array(movieDB.movies.shuffled().prefix(5))
        case .all:
            return movieDB.movies
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.callout.bold())
                .kerning(0.56)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(filteredMovies) { movie in
                        imageV(path: $path,
                              imageUrl: movie.thumbnailVUrl,
                              movieId: movie.id)
                    }
                }
            }
        }
        .padding(.leading, 25)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

// Define categories
enum MovieCategory {
    case action
    case animation
    case drama
    case sciFi
    case trending
    case random
    case all
}

#Preview {
    CategoryScroll(path: .constant(NavigationPath()), category: .random, title: "Action")
}
