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
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?

    func loadImage(from url: String) {
        if let cachedImage = ImageCache.getCachedImage(for: url) {
            self.image = cachedImage
            return
        }

        guard let imageURL = URL(string: url) else { return }

        cancellable = URLSession.shared.dataTaskPublisher(for: imageURL)
            .map(\.data)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .sink { [weak self] in
                if let image = $0 {
                    ImageCache.cacheImage(image, for: url)
                }
                self?.image = $0
            }
    }


    func cancel() {
        cancellable?.cancel()
    }
}
