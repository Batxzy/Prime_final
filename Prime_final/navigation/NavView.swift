//
//  NavView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI

struct Navbar: View {
    var body: some View {
        HStack(alignment: .top) {
            
            VStack(alignment: .center, spacing: 6){
                Image("tabler_home-2")
                    .frame(width: 24, height: 24).foregroundColor(.white)
                Text("Home").multilineTextAlignment(.center).foregroundColor(.white).font(.footnote).bold()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            VStack(alignment: .center){
                Image("tab_download")
                    .frame(width: 24, height: 24).foregroundColor(.white)
                
                Text("Download").multilineTextAlignment(.center).foregroundColor(.white).font(.footnote).bold()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.top)
            
            VStack(alignment: .center, spacing: 6){
                Image("tabler_search")
                    .frame(width: 24, height: 24)
                Text("Find").multilineTextAlignment(.center).foregroundColor(.white).font(.footnote).bold()
            }
            
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding(0)
        .frame(width: 390, height: 93, alignment: .topLeading)
        .background(.black)
    }
}
#Preview {
    Navbar()
}
