//
//  SwiftUIView.swift
//  Prime_final
//
//  Created by LAB4CUAAD on 14/11/24.
//

import SwiftUI

struct Tabview: View {
    var body: some View {
        HStack(alignment: .center){
            Image("Vector")
                .frame(width: 79.00001, height: 25.99999)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 10) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(minWidth: 42.5, maxWidth: 42.5, maxHeight: .infinity)
                    .background(Color(red: 0.5, green: 0.5, blue: 0.5))
                    .cornerRadius(11)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(minWidth: 42.5, maxWidth: 42.5, maxHeight: .infinity)
                    .background(Color(red: 0.5, green: 0.5, blue: 0.5))
                    .cornerRadius(11)
            }
            .padding(0).frame(height: 44, alignment: .center)
        }
        .padding(.leading, 25).padding(.trailing, 24).padding(.vertical, 3).frame(width: 390, height: 68,alignment: .leading)
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
