//
//  SwiftUIView.swift
//  Prime_final
//
//  Created by Alumno on 20/11/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var path: NavigationPath
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black,.blue], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(alignment:.center,spacing: 24){
                Image("furry2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 150, maxHeight: 150)
                    .clipShape(Circle())
                
                VStack(spacing: 10){
                    Text("Made with love by:")
                        .font(.title.bold())
                    VStack(spacing: 8){
                        Text("Jose Julian Lopez Huacuja")
                            .font(.system(size: 24,weight: .medium))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    
                }
                .padding(15)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                
                Text("Proyect made with swift ui")
                
                Spacer()
                
                Text("Programacion avanzada 2024")
                    .font(.footnote)
                
            }
            .frame(maxHeight: .infinity,alignment: .top)
            .padding(.top, 56)
            .preferredColorScheme(.dark)
        }
        
    }
}

#Preview {
    SettingsView(path: .constant(NavigationPath()))
}
