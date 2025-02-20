
//
//  RegistrationViewModel.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import FirebaseAuth
import FirebaseFirestore

extension RegistrationView {
   
    class ViewModel: ObservableObject {
        @Published var email = ""
        @Published var password = ""
        @Published var confirmPassword = ""
        @Published var username = ""
        @Published var dateOfBirth = Date()
        @Published var country = ""
        @Published var sexIndex = 0
        @Published var description = ""
        @Published var registrationSuccess = false
        @Published var errorMessage = ""
        
        let sexes = ["Male", "Female"]
        
        func register() {
            guard password == confirmPassword else {
                errorMessage = "Passwords do not match"
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) {result, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let userId = result?.user.uid else { return }
                self.saveUserData(userId: userId)
            }
        }
        
        private func saveUserData(userId: String) {
            let db = FirestoreDB.shared.db
            let userData: [String: Any] = [
                "username": username,
                "registeredAt": Timestamp(),
                "dateOfBirth": dateOfBirth,
                "country": country,
                "sex": sexes[sexIndex],
                "description": description
            ]
            
            db.collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                } else {
                    DispatchQueue.main.async {
                        self.registrationSuccess = true
                    }
                }
            }
        }
    }
    
}
