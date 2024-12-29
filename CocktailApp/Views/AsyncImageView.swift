//
//  AsyncImageView.swift
//  CocktailApp
//
//  Created by Venkat_test on 30/12/2024.
//

import Foundation
import SwiftUI

struct AsyncImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageURL: String

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView() // Show a loading indicator
            }
        }
        .onAppear {
            imageLoader.loadImage(from: imageURL)
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}
