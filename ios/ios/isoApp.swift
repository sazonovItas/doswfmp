//
//  isoApp.swift
//  iso
//
//  Created by Xenona on 19/02/2025.
//

import SwiftUI
import Firebase

@main
struct isoApp: App {
    init() {
        FirebaseApp.configure();
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
