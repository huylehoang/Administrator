import Foundation

enum DownloadImageError: Error, Equatable {
    case downloadFailed
}

extension DownloadImageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .downloadFailed: "Image download failed."
        }
    }
}
