@testable import Administrator
import XCTest
import Foundation

final class DateProviderTests: XCTestCase {
    func test_currentDate_returnsCurrentDate() {
        let sut = DateProvider()
        let date = sut.currentDate()
        let expectedDate = Date()
        XCTAssertEqual(
            date.timeIntervalSinceReferenceDate,
            expectedDate.timeIntervalSinceReferenceDate,
            accuracy: 0.1
        )
    }
}
