//
//  KeyboardListViewModel.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import Foundation
import FirebaseFirestore

extension KeyboardListView {
    
    class ViewModel: ObservableObject {
        @Published private(set) var keyboards = [KeyboardModel]()
        @Published var searchText: String = ""
        @Published var sortOption: SortOption = .name
        @Published var isAscending: Bool = true  // Toggle for ascending/descending order

        private var db = FirestoreDB.shared.db //Firestore.firestore()
        private static let fallbackDate: Date = Date(timeIntervalSince1970: 946684800) // Jan 1, 2000

        enum SortOption: String, CaseIterable {
            case name = "Name"
            case manifacturer = "Manifacturer"
        }

        init() {
            fetchKeyboards(cached: true)
            fetchKeyboards(cached: false)
        }

        func fetchKeyboards(cached: Bool) {
            db.collection("keyboards").getDocuments(source: cached ? .cache : .default) { snapshot, error in
                if let error = error {
                    print("Error fetching tracks: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No keyboards found")
                    return
                }

                DispatchQueue.main.async {
                    self.keyboards = documents.compactMap { doc in
                        let data = doc.data()
                        let id = doc.documentID
                        let name = data["name"] as? String ?? ""
                        let manifacturer = data["manifacturer"] as? String ?? ""
                        let imageUrls = data["imageUrls"] as? [String] ?? []
                        let mainImageId = data["mainImageId"] as? Int ?? 0

                        return KeyboardModel(
                            id: id,
                            name: name,
                            manifacturer: manifacturer,
                            imageUrls: imageUrls,
                            mainImageId: mainImageId
                        )
                    }
                }
            }
        }

        var filteredKeyboards: [KeyboardModel] {
            let lowercasedQuery = searchText.lowercased()
            return keyboards.filter {keyboard in
                searchText.isEmpty ||
                keyboard.name.lowercased().contains(lowercasedQuery) ||
                keyboard.manifacturer.lowercased().contains(lowercasedQuery)
            }.sorted { kb1, kb2 in
                let comparison: Bool
                switch sortOption {
                case .name:
                    comparison = kb1.name < kb2.name
                case .manifacturer:
                    comparison = kb1.manifacturer < kb2.manifacturer
                }
                
                return isAscending ? comparison : !comparison
            }
        }
    }
}



private let sampleKeyboard1 = KeyboardModel (
    id: "some_id",
    name: "Ducky One 2 Pro Classic RGB Double Shot PBT Mechanical Keyboard",
    manifacturer: "Ducky",
    imageUrls:[
        "https://mechanicalkeyboards.com/cdn/shop/files/17518-HAI9W-One-2-Pro-Classic.jpg?v=1708447629&width=2048",
        "https://mechanicalkeyboards.com/cdn/shop/files/17518-WNBS4-One-2-Pro-Classic.jpg?v=1708447629&width=2048"
    ],
    mainImageId: 0
)

private let sampleKeyboard2 = KeyboardModel (
    id: "some_id",
    name: "Ducky One 2 Pro Classic RGB Double Shot PBT Mechanical Keyboard",
    manifacturer: "Ducky",
    imageUrls:[
        "https://mechanicalkeyboards.com/cdn/shop/files/17518-HAI9W-One-2-Pro-Classic.jpg?v=1708447629&width=2048",
        "https://mechanicalkeyboards.com/cdn/shop/files/17518-WNBS4-One-2-Pro-Classic.jpg?v=1708447629&width=2048"
    ],
    mainImageId: 1
)
