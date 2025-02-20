//
//  RatingView.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import SwiftUI

struct RatingView: View {
    let rating: RatingModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(rating.username) rated:")
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating.value ? "star.fill" : "star")
                            .foregroundColor(star <= rating.value ? .yellow : .gray)
                            .font(.headline)
                    }
                }
                
                Text(rating.comment)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

let testRating = RatingModel(
    id: "test",
    userId: "test",
    username: "username",
    value: 4,
    comment: "comment")

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: testRating)
    }
}
