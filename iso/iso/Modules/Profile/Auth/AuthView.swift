//
//  AuthView.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import SwiftUI

struct AuthView: View {
    @Binding var isLoggedIn: Bool
    @Binding var profile: Profile?
    @State private var showingRegister = false
    
    var body: some View {
        VStack {
            Text(showingRegister ? "Create an Account" : "Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            if showingRegister {
                RegistrationView(showingRegister: $showingRegister)
            } else {
                LoginView(showingRegister: $showingRegister, isLoggedIn: $isLoggedIn, profile: $profile)
                
                Spacer()
                
                Button(action : {
                    profile = nil
                    isLoggedIn = true
                }) {
                    Text("Log in Offline")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(isLoggedIn: .constant(false), profile: .constant(nil))
    }
}
