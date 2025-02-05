import UIKit

/// A protocol defining the interface for downloading and caching images.
protocol DownloadImageServiceType {
    /// Downloads an image from the specified URL or retrieves it from the cache.
    /// - Parameter url: The URL of the image to download.
    /// - Returns: A `Result` containing the downloaded image or an error.
    func downloadImage(from url: URL) async -> Result<UIImage, Error>
}

/// A singleton service for downloading and caching images.
final class DownloadImageService: DownloadImageServiceType {
    typealias ImageCache = CacheService<String, UIImage>
    static let shared = DownloadImageService()

    private var imageCache = ImageCache(countLimit: 100, totalCostLimit: 20_000_000)
    private var sessionProvider: SessionProviderType = SessionProvider.shared

    private init() {}

    func set(imageCache: ImageCache) {
        self.imageCache = imageCache
    }

    func set(sessionProvider: SessionProviderType) {
        self.sessionProvider = sessionProvider
    }

    func clearCache() {
        imageCache.clear()
    }

    func downloadImage(from url: URL) async -> Result<UIImage, Error> {
        let cacheKey = url.absoluteString
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return .success(cachedImage)
        }
        do {
            let request = URLRequest(url: url)
            let (data, response) = try await sessionProvider.session().data(for: request)
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let image = UIImage(data: data)
            else {
                return .failure(DownloadImageError.downloadFailed)
            }
            imageCache.setObject(image, forKey: cacheKey)
            return .success(image)
        } catch {
            return .failure(error)
        }
    }
}
