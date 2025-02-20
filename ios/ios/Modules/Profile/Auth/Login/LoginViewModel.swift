//
//  LoginViewModel.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension LoginView {
    
    class ViewModel: ObservableObject {
        @Published var email = ""
        @Published var password = ""
        @Published var errorMessage = ""
        @Published var isLoggedIn = false
        @Published var profile: Profile? = nil
        
        private var db = FirestoreDB.shared.db
        
        private func validateFields() -> Bool {
            guard !email.isEmpty, !password.isEmpty else {
                errorMessage = "Please fill in both fields."
                return false
            }
            
            return true
        }
        
        func login() {
            if !validateFields() {
               return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.isLoggedIn = false
                        self.profile = nil
                    }
                } else {
                    self.fetchProfile()
                }
            }
        }
        
        private func fetchProfile() {
            guard let userId = Auth.auth().currentUser?.uid else {return}
            
            db.collection("users").document(userId).getDocument {document, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Failed to fetch profile data: \(error.localizedDescription)"
                        self.isLoggedIn = false
                        self.profile = nil
                    } else if let document = document, document.exists {
                        let data = document.data()
                        let email = data?[""] as? String ?? ""
                        let username = data?["username"] as? String ?? ""
                        let dateOfBirth = (data?["dateOfBirth"] as? Timestamp)?.dateValue() ?? Date()
                        let country = data?["country"] as? String ?? ""
                        let sex = data?["sex"] as? String ?? ""
                        let description = data?["description"] as? String ?? ""
                        let registeredAt = (data?["registeredAt"] as? Timestamp)?.dateValue() ?? Date()
                        let favorites = data?["favorite"] as? [String] ?? []
                        
                        let userProfile = Profile(
                            email: email,
                            username: username,
                            dateOfBirth: dateOfBirth,
                            country: country,
                            sex: sex,
                            description: description,
                            registeredAt: registeredAt,
                            favorites: favorites
                        )
                        
                        self.errorMessage = ""
                        self.isLoggedIn = true
                        self.profile = userProfile
                    } else {
                        self.errorMessage = "No profie found for this user."
                        self.isLoggedIn = false
                        self.profile = nil
                    }
                }
            }
        }
    }
    
    
}
