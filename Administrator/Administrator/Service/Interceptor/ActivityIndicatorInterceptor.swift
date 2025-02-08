import Foundation

// MARK: - Protocol for Activity Indicator
/// `ActivityIndicatorType` defines the interface for managing the state of a loading indicator.
/// Provides asynchronous methods to activate (`show`) and deactivate (`hide`)
/// the loading indicator.
protocol ActivityIndicatorType {
    func show() async
    func hide() async
}

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
