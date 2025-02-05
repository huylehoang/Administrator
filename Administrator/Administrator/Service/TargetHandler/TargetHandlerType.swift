import Foundation

/// Protocol defining a chain-of-responsibility pattern for handling API targets.
/// Each handler in the chain processes the `TargetType` request and either handles it
/// or forwards it to the next handler in the chain.
///
/// - Designed to promote modularity and flexibility in processing network requests,
///  where each handler has a specific responsibility (e.g., upload, download).
protocol TargetHandlerType: AnyObject {

    /// The next handler in the chain.
    /// If `nil`, this handler is the last in the chain.
    var next: TargetHandlerType? { get set }

    /// Processes the provided target request.
    /// - Parameter target: The API request conforming to `TargetType`.
    /// - Returns: A `TargetResponse` containing the processed result.
    /// - Throws: An error if the request cannot be handled or processing fails.
    func handle<T: TargetType>(target: T) async throws -> TargetResponse<T.DataType>
}

extension TargetHandlerType {

    /// Default implementation of the `next` property.
    /// - Returns: `nil` by default, indicating this handler is the last in the chain.
    var next: TargetHandlerType? {
        get { nil }
        set {}
    }

    /// Configures the next handler in the chain.
    /// - Parameter handler: The next `TargetHandler` in the chain.
    /// - Returns: The newly set handler, allowing for a fluent API style when setting up the chain.
    @discardableResult
    func setNext(_ handler: TargetHandlerType) -> TargetHandlerType {
        self.next = handler
        return handler
    }

    /// Invokes the next handler in the chain, if it exists.
    /// - Parameter target: The API request conforming to `TargetType`.
    /// - Returns: The result from the next handler or throws an `ApiError.unsupportedRequest` 
    /// if no handlers can process the request.
    /// - Throws: `ApiError.unsupportedRequest` if there is no next handler.
    func nextHandle<T: TargetType>(target: T) async throws -> TargetResponse<T.DataType> {
        try await next?.handle(target: target) ?? { throw ApiError.unsupportedRequest }()
    }
}
