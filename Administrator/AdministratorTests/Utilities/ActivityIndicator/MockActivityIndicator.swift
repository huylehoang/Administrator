@testable import Administrator
import Combine

final class MockActivityIndicator: ActivityIndicatorType {
    private(set) var isLoading = false

    init() {}

    func show() {
        isLoading = true
    }

    func hide() {
        isLoading = false
    }
}
