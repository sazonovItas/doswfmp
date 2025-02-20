//
//  LoginView.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = ViewModel()
    @Binding var showingRegister: Bool
    @Binding var isLoggedIn: Bool
    @Binding var profile: Profile?
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
            }
            
            Button(action: {
                viewModel.login()
            }) {
               Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {showingRegister = true}) {
                Text("Don't have an account? Register")
                    .foregroundColor(.blue)
            }
        }.padding().onChange(of: viewModel.isLoggedIn) {newValue in
            isLoggedIn = newValue
            profile = viewModel.profile
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showingRegister: .constant(false),
            isLoggedIn: .constant(false),
            profile: .constant(nil))
    }
}
