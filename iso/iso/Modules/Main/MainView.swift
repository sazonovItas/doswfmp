//
//  MainView.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//
import SwiftUI

struct MainPageView: View {
    @Binding var isLoggedIn: Bool
    @Binding var profile: Profile?

    var body: some View {
        TabView {
            NavigationView {
                KeyboardListView(profile: $profile)
                    .navigationTitle("Keyboards")
            }
            .tabItem {
                Label("Keyboards", systemImage: "keyboard")
            }

            if profile != nil {
                NavigationView {
                    KeyboardListView(profile: $profile, showFavoritesOnly: true) // Favorites tab
                        .navigationTitle("Favorites")
                }
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            }
            
            ProfileView(isLoggedIn: $isLoggedIn, profile: $profile)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}


private let sample_profile = Profile(
    email: "john.doe@example.com",
    username: "john_doe",
    dateOfBirth: Calendar.current.date(byAdding: .year, value: -25, to: Date())!,
    country: "USA",
    sex: "Male",
    description: "A passionate music lover and software developer.",
    registeredAt: Date(),
    favorites: []
)

struct MainPageView_Previews: PreviewProvider {
    @State static var isLoggedIn = false
    @State static var profile: Profile? = nil
    
    static var previews: some View {
        MainPageView(isLoggedIn: $isLoggedIn, profile: $profile)
    }
}
