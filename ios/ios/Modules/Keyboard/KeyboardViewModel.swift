//
//  KeyboardViewModel.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

extension KeyboardView {
    class ViewModel: ObservableObject {
        @Binding var profile: Profile?
        @Published var isFavorite: Bool = false
        @Published var ratings: [RatingModel] = []
        
        private var db = FirestoreDB.shared.db
        
        var keyboard: KeyboardModel
        
        init(keyboard: KeyboardModel, profile: Binding<Profile?>) {
            self.keyboard = keyboard
            self._profile = profile
        }
        
        func fetchRatings() {
            let ratingsRef = db.collection("keyboards").document(keyboard.id).collection("ratings")
            
            ratingsRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching ratings: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    var fetchedRatings: [RatingModel] = []
                    let dispatchGroup = DispatchGroup()
                    
                    for doc in documents {
                        let data = doc.data()
                        guard let userId = data["userId"] as? String,
                              let value = data["value"] as? Int,
                              let comment = data["comment"] as? String else {
                            continue
                        }
                        
                        dispatchGroup.enter()
                        
                        self.db.collection("users").document(userId).getDocument {userSnapshot, error in
                            defer { dispatchGroup.leave() }
                            
                            var username = "Anonymous"
                            
                            if let userData = userSnapshot?.data(), let fetchedUsername = userData["username"] as? String {
                                username = fetchedUsername
                            }
                            
                            let rating = RatingModel(id: doc.documentID, userId: userId, username: username, value: value, comment: comment)
                            fetchedRatings.append(rating)
                        }
                        
                        dispatchGroup.notify(queue: .main) {
                            self.ratings = fetchedRatings
                        }
                    }
                }
                
            }
        }
        
        func addRating(value: Int, comment: String) {
            guard let userId = Auth.auth().currentUser?.uid else {
                return
            }
            
            let username = profile?.username ?? "Anonymous"
            
            let newRating: [String: Any] = [
                "userId": userId,
                "value": value,
                "comment": comment
            ]
            
            let ratingsRef = db.collection("keyboards").document(keyboard.id).collection("ratings")
            
            ratingsRef.addDocument(data: newRating) { error in
                if let error = error {
                    print("Error adding rating: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        let addedRating = RatingModel(id: UUID().uuidString, userId: userId, username: username, value: value, comment: comment)
                        self.ratings.append(addedRating)
                    }
                }
            }
        }
        
        func checkIfFavorite() {
            if let profile = profile {
                isFavorite = profile.favorites.contains(keyboard.id)
            }
        }
        
        func toggleFavoriteStatus() {
            guard let userId = Auth.auth().currentUser?.uid else {return}
            
            if var profile = profile {
                if isFavorite {
                    profile.favorites.removeAll { $0 == keyboard.id }
                } else {
                    profile.favorites.append(keyboard.id)
                }
                
                db.collection("users").document(userId).updateData([
                    "favorites": profile.favorites
                ]) { error in
                    if let error = error {
                        print("Error updating favorite status: \(error.localizedDescription)")
                    } else {
                        self.profile = profile
                        self.isFavorite.toggle()
                    }
                }
            }
        }
    }
}
