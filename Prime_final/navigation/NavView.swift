//
//  NavView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI

enum Tab {
    case home, download, search
}

struct Navbar: View {
    @State private var selectedTab: Tab = .home
        var body: some View {
            NavigationStack {
                HStack(alignment: .top) {
                    // Home Tab
                    NavigationLink(destination: HomeView()) {
                            VStack(alignment: .center, spacing: 6) {
                                Image("tabler_home-2")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(selectedTab == .home ? .white : .gray)
                                Text("Home")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedTab == .home ? .white : .gray)
                                    .font(.footnote)
                                    .bold()
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                        selectedTab = .home
                    })
                    
                    // Download/Watchlist Tab
                        NavigationLink(destination: WatchlistView()) {
                            VStack(alignment: .center, spacing: 6) {
                                Image("tab_download")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(selectedTab == .download ? .white : .gray)
                                Text("Download")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedTab == .download ? .white : .gray)
                                    .font(.footnote)
                                    .bold()
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                        selectedTab = .download
                        })
                        .frame(maxWidth: .infinity)
                    
                    // Search Tab
                        NavigationLink(destination: SearchView()) {
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
                        .simultaneousGesture(TapGesture().onEnded {
                        selectedTab = .search
                        })
                        .frame(maxWidth: .infinity)
                }
                .padding(0)
                .frame(width: 390, height: 93, alignment: .topLeading)
                .background(.black)
        }
    }
}

#Preview {
    Navbar()
}
