import Foundation

protocol DateProviderType {
    func currentDate() -> Date
}

struct DateProvider: DateProviderType {
    init() {}

    func currentDate() -> Date {
        Date()
    }
}
