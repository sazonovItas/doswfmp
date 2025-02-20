//
//  ContentView.swift
//  iso
//
//  Created by Xenona on 19/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var profile: Profile? = nil
    
    var body: some View {
        Group {
            if isLoggedIn {
                MainPageView(isLoggedIn: $isLoggedIn, profile: $profile)
            } else {
                AuthView(isLoggedIn: $isLoggedIn, profile: $profile)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
