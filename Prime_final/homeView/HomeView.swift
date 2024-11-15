//
//  HomeView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {  // Add NavigationView here
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    FirstControl()
                    ScrollVertical(Sectiontitle: "nua es un pendjo xd")
                    ScrollVertical(Sectiontitle: "amazon")
                    ScrollVertical(Sectiontitle: "amazon")
                    ScrollVertical(Sectiontitle: "amazon")
                    ScrollVertical(Sectiontitle: "amazon")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
}

#Preview {
    HomeView().preferredColorScheme(.dark)
}
