import Foundation

/// A protocol defining the API service layer for handling network requests.
/// - Provides a generic method to perform API requests, supporting a wide range of target 
/// configurations.
protocol ApiServiceType {
    /// Sends a network request for the specified target.
    /// - Parameter target: A type conforming to `TargetType` that defines the request
    ///  configuration.
    /// - Returns: A `Result` containing either the successfully decoded data or an `Error`.
    func request<T: TargetType>(target: T) async -> Result<T.DataType, Error>
}

/// A singleton class implementing `ApiServiceType` to manage and execute API requests.
/// - Integrates with interceptors and requesters to provide a highly flexible and extensible
///  networking pipeline.
final class ApiService: ApiServiceType {
    static let shared = ApiService()

    private var requester: TargetRequesterType = TargetRequester()
    private var interceptorPipeline: InterceptorType = InterceptorPipeline()

    private init() {}

    func set(requester: TargetRequesterType) {
        self.requester = requester
    }

    func set(interceptorPipeline: InterceptorType) {
        self.interceptorPipeline = interceptorPipeline
    }

    /// Performs a network request for the given target, applying interceptors at each stage of
    ///  the pipeline.
    func request<T: TargetType>(target: T) async -> Result<T.DataType, Error> {
        let result: Result<T.DataType, Error>
        do {
            // Step 1: Apply interceptors to modify or validate the target.
            let target = try await interceptorPipeline.intercept(target: target)
            // Step 2: Perform the network request using the configured `requester`.
            let response = try await interceptorPipeline.intercept(
                response: try await requester.request(target: target),
                target: target
            )
            // Step 3: Check if the response contains data or return an error.
            if let response = response.response {
                result = .success(response)
            } else {
                result = .failure(ApiError.noDataFound)
            }
        } catch {
            // Capture any error that occurs during the process.
            result = .failure(error)
        }
        // Step 4: Apply result interceptors and optionally retry the request.
        return await interceptorPipeline.intercept(
            result: result,
            target: target,
            retryClosure: { [weak self] in
                // Retry mechanism for recovering from transient errors.
                await self?.retryRequest(target: target) ?? result
            }
        )
    }
}

private extension ApiService {
    func retryRequest<T: TargetType>(target: T) async -> Result<T.DataType, Error> {
        do {
            guard let response = try await requester.request(target: target).response else {
                return .failure(ApiError.noDataFound)
            }
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
