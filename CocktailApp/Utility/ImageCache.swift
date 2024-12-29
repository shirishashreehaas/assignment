//
//  ImageCache.swift
//  CocktailApp
//
//  Created by Venkat_test on 30/12/2024.
//

import Foundation
import UIKit
class ImageCache {
    static let shared = NSCache<NSString, UIImage>()

    static func getCachedImage(for url: String) -> UIImage? {
        return shared.object(forKey: NSString(string: url))
    }

    static func cacheImage(_ image: UIImage, for url: String) {
        shared.setObject(image, forKey: NSString(string: url))
    }
}
