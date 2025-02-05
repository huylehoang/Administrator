import Foundation

enum ApiError: Error, Equatable {
    case invalidURL
    case unsupportedRequest
    case badServerResponse
    case noDataFound
    case unknown
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case .unsupportedRequest: "Unsupported Request"
        case .badServerResponse: "Bad Server Response"
        case .noDataFound: "No Data Found"
        case .unknown: "Something Went Wrong!!!"
        }
    }
}
