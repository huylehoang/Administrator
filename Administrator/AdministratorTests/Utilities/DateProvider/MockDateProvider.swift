@testable import Administrator
import Foundation

final class MockDateProvider: DateProviderType {
    var date = Date()

    func currentDate() -> Date {
        date
    }
}
