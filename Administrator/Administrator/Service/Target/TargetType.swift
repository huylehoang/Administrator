import Foundation

/// Represents the HTTP methods supported by the target API requests.
enum HTTPMethod: String {
    case get, post, put, delete
}

/// Represents the HTTP body of a request.
/// - This can include either parameters (key-value pairs) or raw data (e.g., JSON or binary).
/// - Includes an optional `contentType` to specify the type of content in the body.
enum HTTPBody {

    /// Key-value parameters.
    case parameters([String: Any], contentType: String = "application/json")
    /// Raw data.
    case data(Data, contentType: String = "application/json")

    /// Converts the HTTP body into raw `Data`, if applicable.
    var data: Data? {
        switch self {
        case .parameters(let parameters, _):
            try? JSONSerialization.data(withJSONObject: parameters)
        case .data(let data, _):
            data
        }
    }

    /// The content type of the HTTP body, if specified.
    var contentType: String? {
        switch self {
        case .parameters(_, let contentType): contentType
        case .data(_, let contentType): contentType
        }
    }
}

/// Defines the essential properties and methods for an API target.
/// - A `TargetType` instance encapsulates all the necessary information to make an HTTP request.
protocol TargetType {

    /// The type of data expected as a response from the target API request.
    /// - The `DataType` must conform to the `Decodable` protocol, enabling automatic decoding from 
    /// JSON or other encoded formats.
    /// - This associated type allows the `TargetType` to be generic, supporting a wide range of 
    /// response models.
    associatedtype DataType: Decodable

    /// The scheme of the URL (e.g., "https").
    var scheme: String { get set }
    /// The host of the URL (e.g., "api.github.com").
    var host: String { get set }
    /// The path of the URL (e.g., "/users").
    var path: String { get set }
    /// The HTTP method (e.g., `.get`, `.post`).
    var method: HTTPMethod { get set }
    /// The query parameters for the request.
    var parameters: [String: Any]? { get set }
    /// The HTTP body of the request.
    var body: HTTPBody? { get set }
    /// The headers for the request.
    var headers: [String: String]? { get set }

    /// Creates a `URLRequest` from the target's properties.
    /// - Throws: An `ApiError` if the URL cannot be constructed.
    func createRequest() throws -> URLRequest
}

extension TargetType {
    func createRequest() throws -> URLRequest {
        guard let urlString, let url = URL(string: urlString) else {
            throw ApiError.invalidURL
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = method.rawValue
        encodeBody(in: &request)
        encodeHeaders(in: &request)
        return request
    }

    /// Sets a value for a specific header field.
    mutating func setValue(_ value: String, forHeaderField field: String) {
        if headers == nil {
            headers = [:]
        }
        headers?[field] = value
    }

    /// Sets a value for a specific query parameter.
    mutating func setValue(_ value: String, forParameterField field: String) {
        if parameters == nil {
            parameters = [:]
        }
        parameters?[field] = value
    }

    /// Sets a value for a specific body parameter.
    mutating func setValue(_ value: String, forBodyParameterField field: String) {
        if body == nil {
            body = .parameters([:])
        }
        if case .parameters(var parameters, let contentType) = body {
            parameters[field] = value
            body = .parameters(parameters, contentType: contentType)
        }
    }
}

private extension TargetType {
    var urlString: String? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = parameters?.queryItems
        return urlComponents.string
    }

    func encodeBody(in request: inout URLRequest) {
        if let data = body?.data {
            request.httpBody = data
        }
        if let contentType = body?.contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
    }

    func encodeHeaders(in request: inout URLRequest) {
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    }
}

private extension [String: Any] {
    var queryItems: [URLQueryItem] {
        map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
}
