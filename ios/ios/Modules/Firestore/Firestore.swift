//
//  Firestore.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import FirebaseFirestore

class FirestoreDB {
    static let shared = FirestoreDB()
    
    let db: Firestore
    
    private init() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db = Firestore.firestore()
        db.settings = settings
    }
}
