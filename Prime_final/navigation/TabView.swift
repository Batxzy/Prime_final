//
//  SwiftUIView.swift
//  Prime_final
//
//  Created by LAB4CUAAD on 14/11/24.
//

import SwiftUI

struct Tabview: View {

@EnvironmentObject var navigationManager: NavigationManager
@ObservedObject private var userManager = UserManager.shared
   
    var body: some View { 
        HStack(alignment: .top){
            Image("Vector")
                .frame(width: 80, height: 26)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 10) {

                Image(systemName: "gear")
                    .foregroundColor(.clear)
                    .frame(minWidth: 42.5, maxWidth: 42.5, maxHeight: .infinity)
                
                 Image(userManager.currentUser?.profilePictureName ?? "default_profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 42.5, height: 42.5)
                    .clipShape(Circle())
                    .onTapGesture {
                        navigationManager.navigate(to: .selectAccount)
                    }
                
            }
            .padding(0)
            .frame(height: 44, alignment: .center)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0, green: 0.02, blue: 0.05), location: 0.60),
                    Gradient.Stop(color: .black.opacity(0), location: 1.00),]
                ,startPoint: UnitPoint(x: 0.5, y: 0),endPoint: UnitPoint(x: 0.5, y: 1)))
    }
}

#Preview {
    Tabview()
}
