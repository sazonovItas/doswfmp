//
//  RegistrationView.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = ViewModel()
    @Binding var showingRegister: Bool
  
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                DatePicker("Data of Birth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                    .padding(.horizontal)
                
                TextField("Country", text: $viewModel.country)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Picker("Sex", selection: $viewModel.sexIndex) {
                    ForEach(0..<viewModel.sexes.count, id: \.self) {index in
                        Text(viewModel.sexes[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                TextField("Description", text: $viewModel.description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                }
                
            }
                
                VStack(spacing: 10) {
                    Button(action: viewModel.register) {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showingRegister = false
                    }) {
                        Text("Already have a account? Login")
                            .foregroundColor(.blue)
                    }
            }
        }
        .padding()
        .onReceive(viewModel.$registrationSuccess) {success in
            if success {
                showingRegister = false
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(showingRegister: .constant(false))
    }
}
