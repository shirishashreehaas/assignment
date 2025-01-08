//
//  AsyncImageView.swift
//  CocktailApp
//
//  Created by Venkat_test on 30/12/2024.
//

import Foundation
import SwiftUI


/// A SwiftUI view for asynchronously loading and displaying an image from a URL.
///
/// - Uses the `ImageLoader` class to handle image fetching, caching, and decoding.
struct AsyncImageView: View {
    @StateObject private var imageLoader = ImageLoader() // The state object responsible for managing image loading.
    let imageURL: String // The URL of the image to load.

    var body: some View {
        Group {
            if let image = imageLoader.image {
                // Display the fetched image if available
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill() // Scale the image to fill the available space
            } else {
                // Show a progress view while the image is loading
                ProgressView()
            }
        }
        .onAppear {
            // Trigger the image loading when the view appears
            imageLoader.loadImage(from: imageURL)
        }
        .onDisappear {
            // Cancel the image-loading task when the view disappears
            imageLoader.cancel()
        }
    }
}
