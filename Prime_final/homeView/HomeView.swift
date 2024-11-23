//
//  HomeView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI

struct HomeView: View {
    @Binding var path: NavigationPath
    @StateObject private var movieDB = MovieDatabase.shared
    @State var selectedTab: TabSelection = .home
    
    private var randomCategories: [(MovieCategory, String)] {
        let categories: [(MovieCategory, String)] = [
            (.trending, "Trending Now"),
            (.action, "Action Movies"),
            (.animation, "Animation"),
            (.drama, "Drama"),
            (.sciFi, "Sci-Fi"),
            (.random, "Random Picks"),
            (.all, "All Movies")
        ]
        return categories.shuffled()
    }

    var body: some View {
        ZStack{
            
           switch selectedTab {
            case .home:
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        FirstControl(path: $path)
                        ForEach(randomCategories, id: \.0) { category, title in
                            CategoryScroll(path: $path,category: category,title: title)
                        }
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 100)
                }
            case .watchlist:
               watchlistView(path: $path)
            
           case .search:
               SearchView(path: $path)
            }
            
            Tabview(path: $path)
            // Bottom NavBar
            Navbar(path: $path, selectedTab: $selectedTab)
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}


#Preview {
    HomeView(path: .constant(NavigationPath()))
        .preferredColorScheme(.dark).environmentObject(UserManager())
}
