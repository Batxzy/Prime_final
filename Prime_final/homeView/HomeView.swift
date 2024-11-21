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
    @State private var selectedTab: TabSelection = .home

    var body: some View {
        ZStack{
            
           switch selectedTab {
            case .home:
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        FirstControl(path: $path)
                        ScrollVertical(path: $path, Sectiontitle: "Featured")
                        ScrollVertical(path: $path, Sectiontitle: "Amazon Originals")
                        ScrollVertical(path: $path, Sectiontitle: "Movies")
                        ScrollVertical(path: $path, Sectiontitle: "TV Shows")
                        ScrollVertical(path: $path, Sectiontitle: "Kids")
                    }
                    .padding(.top, 60)
                }
            case .watchlist:
                watchlistView()
            case .settings:
                SettingView(path: $path)
            }
            
            Tabview(path: $path)
            // Bottom NavBar
            Navbar(path: $path)
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}


#Preview {
    HomeView(path: .constant(NavigationPath()))
        .preferredColorScheme(.dark)
}
