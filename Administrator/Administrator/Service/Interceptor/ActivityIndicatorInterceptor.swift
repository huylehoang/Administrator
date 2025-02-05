import Foundation

final class ActivityIndicatorInterceptor: InterceptorType {
    private let activityIndicator: ActivityIndicatorType

    init(activityIndicator: ActivityIndicatorType = ActivityIndicatorManager.shared) {
        self.activityIndicator = activityIndicator
    }

    func intercept<T: TargetType>(target: T) async throws -> T {
        await activityIndicator.show()
        return target
    }

    func intercept<T: TargetType>(
        result: Result<T.DataType, Error>,
        target: T,
        retryClosure: (() async throws -> Result<T.DataType, Error>)?
    ) async -> Result<T.DataType, Error> {
        await activityIndicator.hide()
        return result
    }
}
