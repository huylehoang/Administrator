import SwiftUI

struct AsyncImageView: View {
    private let url: URL
    private let service: DownloadImageServiceType
    @State private var image: UIImage?
    @State private var isLoading = false

    init(url: URL, service: DownloadImageServiceType = DownloadImageService.shared) {
        self.url = url
        self.service = service
    }

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
            } else {
                Color.gray.opacity(0.2)
            }
        }
        .onAppear(perform: loadImage)
    }
}

private extension AsyncImageView {
    @MainActor
    func loadImage() {
        guard !isLoading, image == nil else { return }
        isLoading = true
        Task {
            defer { isLoading = false }
            switch await service.downloadImage(from: url) {
            case .success(let image):
                self.image = image
            case .failure:
                break
            }
        }
    }
}
