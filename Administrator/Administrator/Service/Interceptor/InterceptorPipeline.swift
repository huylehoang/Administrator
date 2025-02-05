import Foundation

final class InterceptorPipeline: InterceptorType {
    private(set) var interceptors = [InterceptorType]() // Maintains insertion order
    private var uniqueInterceptors = Set<ObjectIdentifier>() // Tracks uniqueness

    static func defaultInterceptors() -> [InterceptorType] {
        [
            LoggerInterceptor(),
            ActivityIndicatorInterceptor()
        ]
    }

    init(interceptors: [InterceptorType] = InterceptorPipeline.defaultInterceptors()) {
        self.interceptors = interceptors
    }

    func add(interceptor: InterceptorType) {
        let typeId = ObjectIdentifier(type(of: interceptor))
        // Only add if the interceptor type is unique
        if uniqueInterceptors.insert(typeId).inserted {
            interceptors.append(interceptor)
        }
    }

    func add(interceptors: [InterceptorType]) {
        for interceptor in interceptors {
             add(interceptor: interceptor)
        }
    }

    func intercept<T: TargetType>(target: T) async throws -> T {
        var target = target
        for interceptor in interceptors {
            target = try await interceptor.intercept(target: target)
        }
        return target
    }

    func intercept<T: TargetType>(
        response: TargetResponse<T.DataType>,
        target: T
    ) async throws -> TargetResponse<T.DataType> {
        var response = response
        for interceptor in interceptors {
            response = try await interceptor.intercept(response: response, target: target)
        }
        return response
    }

    func intercept<T: TargetType>(
        result: Result<T.DataType, Error>,
        target: T,
        retryClosure: (() async throws -> Result<T.DataType, Error>)?
    ) async -> Result<T.DataType, Error> {
        var result = result
        for interceptor in interceptors {
            result = await interceptor.intercept(
                result: result,
                target: target,
                retryClosure: retryClosure
            )
        }
        return result
    }
}
