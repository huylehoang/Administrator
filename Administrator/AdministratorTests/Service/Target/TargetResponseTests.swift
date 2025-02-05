@testable import Administrator
import XCTest

final class TargetResponseTests: XCTestCase {
    func test_init_withAllParameters() {
        let mockResponse = MockResponse(message: "Success")
        let mockData = "{\"message\": \"Success\"}".data(using: .utf8)
        let statusCode = 200
        let targetResponse = TargetResponse(
            response: mockResponse,
            data: mockData,
            statusCode: statusCode
        )
        XCTAssertEqual(targetResponse.response, mockResponse)
        XCTAssertEqual(targetResponse.data, mockData)
        XCTAssertEqual(targetResponse.statusCode, statusCode)
    }

    func test_init_withNilParameters() {
        let targetResponse = TargetResponse<MockResponse>(response: nil, data: nil, statusCode: 404)
        XCTAssertNil(targetResponse.response)
        XCTAssertNil(targetResponse.data)
        XCTAssertEqual(targetResponse.statusCode, 404)
    }
}
