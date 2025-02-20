//
//  KeyboardCardView.swift
//  iso
//
//  Created by Xenona on 20/02/2025.
//
import SwiftUI

struct KeyboardCardView: View {
    let keyboard : KeyboardModel
    let imageWidth : CGFloat = UIScreen.main.bounds.width * 0.4
    
    var body: some View {
        HStack(spacing: 16) {
            if let imageUrl = keyboard.imageUrls[safe: keyboard.mainImageId],
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: self.imageWidth, height: self.imageWidth) // Larger square image
                        .clipped()
                        .cornerRadius(10)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: self.imageWidth, height: self.imageWidth) // Square placeholder
                        .overlay(
                            Text("No Image")
                                .foregroundColor(.white)
                                .font(.caption)
                        )
                }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: self.imageWidth, height: self.imageWidth) // Square placeholder
                    .overlay(
                        Text("No Image")
                            .foregroundColor(.white)
                            .font(.caption)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(keyboard.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .bold()
                
                Text(keyboard.manifacturer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


struct KeyboardCardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardCardView(keyboard: sampleKeyboard)
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

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIView {
    public var viewWidth: CGFloat {
        return self.frame.size.width
    }

    public var viewHeight: CGFloat {
        return self.frame.size.height
    }
}
