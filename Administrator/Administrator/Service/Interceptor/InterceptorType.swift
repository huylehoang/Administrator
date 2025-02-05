import Foundation

/// - A protocol defining the structure for interceptors in a networking layer.
/// - Interceptors are used to modify or inspect requests, responses, or results in a consistent
/// manner before they are passed through the networking pipeline.
/// - Use cases include logging, retrying, authentication, request modification, and response 
/// handling.
protocol InterceptorType {

    /// Intercepts and optionally modifies an outgoing request target.
    /// - Parameter target: The original target request conforming to `TargetType`.
    /// - Returns: The modified or original `TargetType` request after interception.
    func intercept<T: TargetType>(target: T) async throws -> T

    /// Intercepts the response received from the server.
    /// - Parameters:
    ///   - response: The server's response wrapped in a `TargetResponse` object.
    ///   - target: The original request target associated with this response.
    /// - Returns: The modified or original `TargetResponse` after interception.
    func intercept<T: TargetType>(
        response: TargetResponse<T.DataType>,
        target: T
    ) async throws -> TargetResponse<T.DataType>

    /// Intercepts the final result of a request operation, whether it succeeded or failed.
    /// - Parameters:
    ///   - result: The result of the request, containing either the successful data or an error.
    ///   - target: The original request target associated with this result.
    ///   - retryClosure: A closure to retry the request if needed.
    /// - Returns: The modified or original result after interception.
    func intercept<T: TargetType>(
        result: Result<T.DataType, Error>,
        target: T,
        retryClosure: (() async throws -> Result<T.DataType, Error>)?
    ) async -> Result<T.DataType, Error>
}

extension InterceptorType {
    func intercept<T: TargetType>(target: T) async throws -> T {
        target
    }

    func intercept<T: TargetType>(
        response: TargetResponse<T.DataType>,
        target: T
    ) async throws -> TargetResponse<T.DataType> {
        response
    }

    func intercept<T: TargetType>(
        result: Result<T.DataType, Error>,
        target: T,
        retryClosure: (() async throws -> Result<T.DataType, Error>)?
    ) async -> Result<T.DataType, Error> {
        result
    }
}
