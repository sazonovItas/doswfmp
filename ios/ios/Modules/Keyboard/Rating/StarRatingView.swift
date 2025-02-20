//
//  StarRatingView.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    
    var maxRating: Int
    
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundColor(star <= rating ? .yellow : .gray)
                    .onTapGesture {
                        rating = star
                    }
                    .padding(2)
            }
        }
    }
}
