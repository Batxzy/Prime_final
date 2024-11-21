//
//  NavView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI

enum Tab {
    case home, watchlist, search
}


struct Navbar: View {

    @Binding var path: NavigationPath
    @Binding var selectedTab: TabSelection
    
        var body: some View {
            VStack{
                HStack(alignment: .top) {
                    // Home Tab
                    Button (action: {   
                        selectedTab = .home
                    }) {
                        VStack(alignment: .center, spacing: 6) {
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedTab == .home ? .white : .gray)
                            Text("Home")
                                .multilineTextAlignment(.center)
                                .foregroundColor(selectedTab == .home ? .white : .gray)
                                .font(.footnote).bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Download/Watchlist Tab
                    Button (action: {   
                        selectedTab = .watchlist
                    }) {
                        VStack(alignment: .center, spacing: 6) {
                            Image(systemName: "arrow.down.square")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedTab == .watchlist ? .white : .gray)
                            Text("Watchlist")
                                .multilineTextAlignment(.center)
                                .foregroundColor(selectedTab == .watchlist ? .white : .gray)
                                .font(.footnote)
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Search Tab
                    Button (action: {   
                        selectedTab = .search
                    }) {
                        VStack(alignment: .center, spacing: 6) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedTab == .search ? .white : .gray)
                            Text("Find")
                                .multilineTextAlignment(.center)
                                .foregroundColor(selectedTab == .search ? .white : .gray)
                                .font(.footnote)
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(0)
                .frame(maxWidth: .infinity,maxHeight: 90)
                .background(.black)
            }
            .frame(maxWidth: .infinity,  maxHeight: .infinity,alignment:.bottom)
    }

}

#Preview {
    Navbar(path: .constant(NavigationPath()), selectedTab: .constant(.home))
}
