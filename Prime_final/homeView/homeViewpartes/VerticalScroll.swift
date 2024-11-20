//
//  SwiftUIView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI
//MARK: imageV
struct imageV: View {
@EnvironmentObject var navigationManager: NavigationManager
    let imageUrl: String
    let movieId: Int
    
    var body: some View {

        Image("\(imageUrl)")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 209)
            .clipped()
            .cornerRadius(10)
            .onTapGesture {
                path.append(AppRoute.movieDetail(movieId))
            }
    }
}


//MARK: ScrollVertical
struct ScrollVertical: View {
    @StateObject private var movieDB = MovieDatabase.shared
    @Binding var path: NavigationPath
    let Sectiontitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(Sectiontitle)")
                .font(.callout.bold())
                .kerning(0.56)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                     ForEach(movieDB.movies) { movie in
                        imageV(imageUrl: movie.thumbnailVUrl, 
                              movieId: movie.id,
                              path: $path)
                    }
                }
            }
        }
        .padding(.leading, 25)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

#Preview {
    ScrollVertical(Sectiontitle: "Amazon orignals and recommended")
}
