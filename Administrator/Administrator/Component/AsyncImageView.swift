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
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .padding(8)
                    }
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
        if !isLoading && image == nil {
            isLoading = true
            Task {
                defer { isLoading = false }
                if case .success(let image) = await service.downloadImage(from: url) {
                    self.image = image
                }
            }
        }
    }
}
