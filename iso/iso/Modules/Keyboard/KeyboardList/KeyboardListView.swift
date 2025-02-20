//
//  KeyboardListView.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import SwiftUI

struct KeyboardListView: View {
    @ObservedObject var viewModel = ViewModel()
    @Binding var profile: Profile?
    var showFavoritesOnly: Bool = false

    var filteredKeyboards: [KeyboardModel] {
        guard let profile = profile else { return viewModel.filteredKeyboards }
        return showFavoritesOnly 
            ? viewModel.filteredKeyboards.filter { profile.favorites.contains($0.id) }
            : viewModel.filteredKeyboards
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if !showFavoritesOnly {
                    // Search Bar
                    TextField("Search Keyboards", text: $viewModel.searchText)
                        .padding()
                        .cornerRadius(8)
                        .padding(.horizontal)

                    // Sort Options
                    HStack {
                        Text("Sort By:")
                            .font(.headline)

                        Picker("Sort By", selection: $viewModel.sortOption) {
                            ForEach(KeyboardListView.ViewModel.SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())

                        Spacer()

                        Button(action: { viewModel.isAscending.toggle() }) {
                            Text(viewModel.isAscending ? "Asc" : "Desc")
                                .padding(8)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }

                // Track List
                LazyVStack(spacing: 16) {
                    ForEach(filteredKeyboards) { keyboard in
                        NavigationLink(destination: KeyboardView(profile: $profile, keyboard: keyboard)) {
                            KeyboardCardView(keyboard: keyboard)
                        }
                    }
                }
                .padding()
            }
        }
    }
}


struct KeyboardListView_Previews: PreviewProvider {

    @State static var my_sample_profile: Profile? = Profile(
        email: "john.doe@example.com",
        username: "john_doe",
        dateOfBirth: Calendar.current.date(byAdding: .year, value: -25, to: Date())!,
        country: "USA",
        sex: "Male",
        description: "A passionate music lover and software developer.",
        registeredAt: Date(),
        favorites: []
    )
    

    static var previews: some View {
        NavigationView {
            KeyboardListView(viewModel: KeyboardListView.ViewModel(), profile: $my_sample_profile)
        }
    }
}

