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
    
    var body: some View {
        VStack(spacing: 0) {
            // Top TabView
            Tabview()
            
            // Main Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    FirstControl(path: $path)
                    ScrollVertical(path: $path, Sectiontitle: "Featured")
                    ScrollVertical(path: $path, Sectiontitle: "Amazon Originals")
                    ScrollVertical(path: $path, Sectiontitle: "Movies")
                    ScrollVertical(path: $path, Sectiontitle: "TV Shows")
                    ScrollVertical(path: $path, Sectiontitle: "Kids")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            
            // Bottom NavBar
            Navbar(path: $path)
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}


#Preview {
    HomeView().preferredColorScheme(.dark)
}
