@testable import Administrator
import XCTest

final class ApiErrorTests: XCTestCase {
    func testApiErrorLocalizedDescription() {
        XCTAssertEqual(ApiError.invalidURL.localizedDescription, "Invalid URL")
        XCTAssertEqual(ApiError.unsupportedRequest.localizedDescription, "Unsupported Request")
        XCTAssertEqual(ApiError.badServerResponse.localizedDescription, "Bad Server Response")
        XCTAssertEqual(ApiError.noDataFound.localizedDescription, "No Data Found")
        XCTAssertEqual(ApiError.unknown.localizedDescription, "Something Went Wrong!!!")
    }
}
