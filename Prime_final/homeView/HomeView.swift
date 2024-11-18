//
//  HomeView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager
       var body: some View {
        VStack(spacing: 0) {
            // Top TabView
            Tabview()
            
            // Main Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    FirstControl()
                    ScrollVertical(Sectiontitle: "Featured")
                    ScrollVertical(Sectiontitle: "Amazon Originals")
                    ScrollVertical(Sectiontitle: "Movies")
                    ScrollVertical(Sectiontitle: "TV Shows")
                    ScrollVertical(Sectiontitle: "Kids")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            
            // Bottom NavBar
            Navbar()
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}


#Preview {
    HomeView().preferredColorScheme(.dark)
}
