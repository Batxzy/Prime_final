//
//  SwiftUIView.swift
//  Prime_final
//
//  Created by Alumno on 20/11/24.
//

import SwiftUI
import WebKit


struct GIFView: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let url = URL(fileURLWithPath: gifPath)
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

struct SettingsView: View {
    @Binding var path: NavigationPath
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black,.blue], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(alignment:.center,spacing: 24){
                GIFView(gifName: "jack-get-real")
                    .frame(maxWidth: 150, maxHeight: 150)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                
                VStack(spacing: 10){
                    Text("Made with ♥ by:")
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
                .shadow(radius: 10, x: 0, y: 10)
                
                Text("Proyect made with SwiftUi and GitHub")
                
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
