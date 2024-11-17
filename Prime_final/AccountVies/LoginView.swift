//
//  LoginView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var userManager = UserManager.shared
    @State private var username = ""
    @State private var password = ""
    @State private var isSecured: Bool = true
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .black, location: 0.28),
                    Gradient.Stop(color: Color(red: 0.03, green: 0.16, blue: 0.27), location: 0.65),
                    Gradient.Stop(color: Color(red: 0.1, green: 0.6, blue: 1), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Image("Prime")
                    .resizable()
                    .clipped()
                    .frame(width: 244, height: 76)
                
                VStack(alignment: .center, spacing: 25) {

                    // Username
                    VStack(alignment: .leading,spacing: 10){
                            Text("Username").font(.callout.bold()).foregroundColor(.white)

                            TextField("Username", text: $username)
                                .preferredColorScheme(.dark)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.white.opacity(0.05))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .inset(by: 1.5)
                                        .stroke(.white.opacity(0.07), lineWidth: 3)
                                    )
                        }
                    .frame(maxWidth: .infinity, maxHeight: 78, alignment: .topLeading)
                    
                    // Password
                    VStack(alignment: .leading,spacing: 10){

                            Text("Password")
                            .font(.callout.bold()).foregroundColor(.white)

                            HStack {
                                (isSecured ? SecureField("Password", text: $password) : TextField("Password", text: $password))
                                    .preferredColorScheme(.dark)
                                    .frame(maxWidth: .infinity, minHeight: 58)
                                
                                Spacer()
                                
                                Button (action:{isSecured.toggle()} )  {
                                    Image(systemName: isSecured ? "eye.fill" : "eye.slash.fill")
                                        .foregroundStyle(.white.opacity(0.8))
                                }
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white.opacity(0.05))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 1.5)
                                    .stroke(.white.opacity(0.07), lineWidth: 3)
                            )
                        }
                    .frame(maxWidth: .infinity, maxHeight: 78, alignment: .topLeading)
                        
                   // Login Button     
                   Button("Login") {
                            if userManager.login(username: username, password: password) {
                    // Login successful
                    username = ""
                    password = ""
                        } else {
                            showError = true
                            errorMessage = "Invalid username or password"
                        }
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(10)
                    .frame(maxWidth: .infinity,minHeight: 48)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal,25)
                    
                    Button("New? Create a new Account") {
                        userManager.currentScreen = .createAccount
                    }
                            .underline(true, pattern: .solid)
                            .foregroundColor(.white)
            }
                .frame(maxWidth: .infinity,alignment: .center)
                .padding(.horizontal,35)
            }
            .alert("Error", isPresented: $showError) {
                        Button("dissmis") { }
                            } message: {
                                Text(errorMessage)
                                    }
        }
    }
}

#Preview {
    LoginView()
}