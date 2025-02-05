import Foundation

/// A protocol defining the behavior of a target requester.
/// - The `TargetRequesterType` protocol abstracts the logic for making API requests,
///  allowing for dependency injection and testability.
protocol TargetRequesterType {
    func request<T: TargetType>(target: T) async throws -> TargetResponse<T.DataType>
}

/// A concrete implementation of the `TargetRequesterType` protocol.
/// - This class acts as the primary interface for initiating API requests by delegating
///  the request-handling logic to a chain of handlers provided by the `TargetHandlerProvider`.
final class TargetRequester: TargetRequesterType {
    private let handlerProvider: TargetHandlerProviderType

    init(handlerProvider: TargetHandlerProviderType = TargetHandlerProvider()) {
        self.handlerProvider = handlerProvider
    }

    /// Makes a request for the given target by delegating it to the appropriate handler
    ///  in the chain. The request flows through the chain of responsibility
    func request<T: TargetType>(target: T) async throws -> TargetResponse<T.DataType> {
        try await handlerProvider.handler.handle(target: target)
    }
}
