//
//  ImageCacheLoader.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import UIKit

/// This class handles caching images for reuse.
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, UIImage>()
    
    /// Retrieves an image from the cache using its URL.
    ///
    /// - Parameters:
    ///   - key: The URL of the image.
    /// - Returns: UIImage loaded from cache is returned
    func getImage(forKey key: NSURL) -> UIImage? {
        return cache.object(forKey: key)
    }
    
    /// Stores an image in the cache using its URL as the key.
    ///
    /// - Parameters:
    ///   - image: The `UIIMage` which needs to be cached aganest its url
    ///   - key : The `NSURL` of the image is used as the key for caching
    /// - Returns: Nil
    func setImage(_ image: UIImage, forKey key: NSURL) {
        cache.setObject(image, forKey: key)
    }
}

/// This class asynchronously loads images from a URL and caches them.
class AsyncImageLoader {
    private var cache = ImageCache.shared
    
    /// Asynchronously loads an image from a URL, caching it for reuse.
    ///
    /// - Parameter url: The URL of the image.
    /// - Returns: The loaded image.
    func loadImage(from url: URL) async throws -> UIImage? {
        let nsUrl = url as NSURL
        
        // Check if the image is already cached
        if let cachedImage = cache.getImage(forKey: nsUrl) {
            return cachedImage
        }
        
        // Download the image data
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Create the image
        if let image = UIImage(data: data) {
            cache.setImage(image, forKey: nsUrl) // Cache the image
            return image
        } else {
            throw URLError(.cannotDecodeContentData)
        }
    }
}
