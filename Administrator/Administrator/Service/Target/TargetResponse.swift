import Foundation

/// Represents a response from a target API request.
/// - Encapsulates both the decoded response object and raw response data.
struct TargetResponse<T: Decodable> {
    /// The decoded response object.
    let response: T?
    /// The raw response data.
    let data: Data?
    /// The HTTP status code.
    let statusCode: Int

    /// Initializes a `TargetResponse` with optional components.
    /// - Parameters:
    ///   - response: The decoded response object.
    ///   - data: The raw response data.
    ///   - statusCode: The HTTP status code.
    init(response: T? = nil, data: Data? = nil, statusCode: Int) {
        self.response = response
        self.data = data
        self.statusCode = statusCode
    }
}
