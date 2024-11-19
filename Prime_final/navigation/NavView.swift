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

    @EnvironmentObject var navigationManager: NavigationManager
    @State private var selectedTab: Tab = .home
        var body: some View {
                HStack(alignment: .top) {
                    // Home Tab
                    Button (action: {   
                            selectedTab = .home
                            navigationManager.navigate(to: .home)
                        }) {
                            VStack(alignment: .center, spacing: 6) {
                                Image("tabler_home-2")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(selectedTab == .home ? .white : .gray)
                                Text("Home")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedTab == .home ? .white : .gray)
                                    .font(.footnote).bold()
                            }
                        }   
                    
                    // Download/Watchlist Tab
                    Button (action: {   
                            selectedTab = .watchlist
                            navigationManager.navigate(to: .watchlist)
                        }) {
                            VStack(alignment: .center, spacing: 6) {
                                Image("tab_download")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(selectedTab == .watchlist ? .white : .gray)
                                Text("Watchlist")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedTab == .watchlist ? .white : .gray)
                                    .font(.footnote)
                                    .bold()
                            }
                        }
                    
                    // Search Tab
                     Button (action: {   
                            selectedTab = .search
                            navigationManager.navigate(to: .search)
                        }) {
                            VStack(alignment: .center, spacing: 6) {
                                Image("tabler_search")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(selectedTab == .search ? .white : .gray)
                                Text("Find")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedTab == .search ? .white : .gray)
                                    .font(.footnote)
                                    .bold()
                            }
                        }
                }
                .padding(0)
                .frame(width: 390, height: 93, alignment: .topLeading)
                .background(.black)
    }
}

#Preview {
    Navbar()
}
