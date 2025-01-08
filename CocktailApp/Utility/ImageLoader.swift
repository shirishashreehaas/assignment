//
//  ImageLoader.swift
//  CocktailApp
//
//  Created by Venkat_test on 30/12/2024.
//

import Foundation
import SwiftUI
import Combine


class ImageLoader: ObservableObject {
    @Published var image: UIImage? // The loaded image, published for binding to UI.

    private var cancellable: AnyCancellable? // A cancellable object for managing the subscription.

    /// Loads an image from the provided URL string.
    ///
    /// - If the image is available in the cache, it is immediately set without making a network request.
    /// - If the image is not cached, it is fetched asynchronously from the provided URL.
    ///
    /// - Parameter url: A `String` representing the image URL to load.
    func loadImage(from url: String) {
        // Check the cache for an existing image
        if let cachedImage = ImageCache.getCachedImage(for: url) {
            self.image = cachedImage // Use the cached image
            return
        }

        // Convert the string URL into a `URL` object
        guard let imageURL = URL(string: url) else { return }

        // Fetch the image using Combine's dataTaskPublisher
        cancellable = URLSession.shared.dataTaskPublisher(for: imageURL)
            .map(\.data) // Extract the data from the response
            .subscribe(on: DispatchQueue.global(qos: .background)) // Perform network call on a background thread
            .map { UIImage(data: $0) } // Convert the data to a UIImage
            .receive(on: DispatchQueue.main) // Update the image property on the main thread
            .replaceError(with: nil) // Handle errors by replacing with nil
            .sink { [weak self] in
                // Cache the image and update the property
                if let image = $0 {
                    ImageCache.cacheImage(image, for: url) // Cache the fetched image
                }
                self?.image = $0 // Set the image property
            }
    }

    /// Cancels the ongoing image loading task.
    func cancel() {
        cancellable?.cancel() // Cancel the Combine subscription
    }
}
