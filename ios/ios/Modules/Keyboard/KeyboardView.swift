//
//  KeyboardView.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import SwiftUI

struct KeyboardView: View {
    @Binding var profile: Profile?
    let keyboard: KeyboardModel

    @StateObject private var viewModel: ViewModel

    @State private var ratingValue: Int = 3
    @State private var ratingComment: String = ""

    init(profile: Binding<Profile?>, keyboard: KeyboardModel) {
        self._profile = profile
        self.keyboard = keyboard
        _viewModel = StateObject(wrappedValue: ViewModel(keyboard: keyboard, profile: profile))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(keyboard.imageUrls, id: \.self) { imageUrl in
                            if let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        placeholderView
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 250)
                                            .cornerRadius(10)
                                    case .failure:
                                        placeholderView
                                    @unknown default:
                                        placeholderView
                                    }
                                }
                            } else {
                                placeholderView
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Text("\(keyboard.name)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .redacted(reason: keyboard.name.isEmpty ? .placeholder : [])
                
                Text("Manifacturer: \(keyboard.manifacturer)")
                    .font(.headline)
                    .redacted(reason: keyboard.manifacturer.isEmpty ? .placeholder : [])
                
                Text("Images Available: \(keyboard.imageUrls.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .redacted(reason: keyboard.imageUrls.isEmpty ? .placeholder : [])
                
                Spacer()

                if profile != nil {
                    Text("Add Your Rating")
                        .font(.headline)
                        .padding(.top)
        
                    StarRatingView(rating: $ratingValue, maxRating: 5)
        
                    TextField("Leave a comment...", text: $ratingComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
        
                    Button(action: {
                        viewModel.addRating(value: ratingValue, comment: ratingComment)
                        ratingComment = ""
                    }) {
                        Text("Submit Rating")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                } else {
                    Text("Please log in to leave a rating.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }

                Text("Ratings")
                    .font(.title2)
                    .padding(.top)

                ForEach(viewModel.ratings) { rating in
                    RatingView(rating: rating)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationTitle(keyboard.name.isEmpty ? "Keyboard Details" : keyboard.name)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            Button(action: {
                viewModel.toggleFavoriteStatus()
            }) {
                Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.title)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.7))
                    )
                    .shadow(radius: 5)
            }
            .position(x: UIScreen.main.bounds.width - 40, y: 40),
            alignment: .topTrailing
        )
        .onAppear {
            viewModel.checkIfFavorite()
            viewModel.fetchRatings()
        }
    }

    var placeholderView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 250, height: 250)
            .overlay(
                Text("No Image")
                    .foregroundColor(.white)
                    .font(.caption)
            )
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct KeyboardView_Previews: PreviewProvider {
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
        KeyboardView(profile: $my_sample_profile, keyboard: sampleKeyboard)
    }
}

private let sampleKeyboard = KeyboardModel (
    id: "some_id",
    name: "Ducky One 2 Pro Classic RGB Double Shot PBT Mechanical Keyboard",
    manifacturer: "Ducky",
    imageUrls:[
        "https://mechanicalkeyboards.com/cdn/shop/files/17518-HAI9W-One-2-Pro-Classic.jpg?v=1708447629&width=2048",
        "https://mechanicalkeyboards.com/cdn/shop/files/17518-WNBS4-One-2-Pro-Classic.jpg?v=1708447629&width=2048"
    ],
    mainImageId: 0
)
