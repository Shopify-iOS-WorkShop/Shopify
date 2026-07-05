import SwiftUI

/// A cached async image view that prevents the NSURLErrorDomain Code=-999 cancellation issue
/// that commonly occurs with SwiftUI's built-in AsyncImage in lists.
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var loadError: Error?
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else if isLoading {
                placeholder()
            } else if loadError != nil {
                placeholder()
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }
    
    @MainActor
    private func loadImage() async {
        guard let url = url else { return }
        
        // Check if already loaded
        if image != nil { return }
        
        isLoading = true
        loadError = nil
        
        // Check cache first
        if let cached = ImageCache.shared.get(forKey: url.absoluteString) {
            self.image = cached
            self.isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let loadedImage = UIImage(data: data) {
                ImageCache.shared.set(loadedImage, forKey: url.absoluteString)
                self.image = loadedImage
            } else {
                self.loadError = NSError(domain: "ImageLoading", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
            }
        } catch {
            self.loadError = error
        }
        
        isLoading = false
    }
}

/// Simple in-memory image cache
final class ImageCache {
    static let shared = ImageCache()
    
    private var cache: [String: UIImage] = [:]
    private let queue = DispatchQueue(label: "com.app.imagecache")
    private let maxCacheSize = 50 // Maximum number of images to cache
    
    private init() {}
    
    func get(forKey key: String) -> UIImage? {
        queue.sync {
            cache[key]
        }
    }
    
    func set(_ image: UIImage, forKey key: String) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            // Simple cache eviction: remove oldest if cache is full
            if self.cache.count >= self.maxCacheSize {
                if let firstKey = self.cache.keys.first {
                    self.cache.removeValue(forKey: firstKey)
                }
            }
            
            self.cache[key] = image
        }
    }
    
    func clear() {
        queue.async { [weak self] in
            self?.cache.removeAll()
        }
    }
}
