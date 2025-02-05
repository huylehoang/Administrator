@testable import Administrator
import XCTest

final class ActivityIndicatorInterceptorTests: XCTestCase {
    private var mockActivityIndicator: MockActivityIndicator!
    private var sut: ActivityIndicatorInterceptor!

    override func setUp() {
        super.setUp()
        mockActivityIndicator = MockActivityIndicator()
        sut = ActivityIndicatorInterceptor(activityIndicator: mockActivityIndicator)
    }

    override func tearDown() {
        sut = nil
        mockActivityIndicator = nil
        super.tearDown()
    }

    func testInterceptTarget_shouldShowActivityIndicator() async throws {
        let target = MockTarget()
        let interceptedTarget = try await sut.intercept(target: target)
        let request = try target.createRequest()
        let interceptedRequest = try interceptedTarget.createRequest()
        XCTAssertTrue(mockActivityIndicator.isLoading)
        XCTAssertEqual(request, interceptedRequest)
    }

    func testInterceptResult_shouldHideActivityIndicator() async {
        let target = MockTarget()
        let result: Result<MockResponse, Error> = .success(MockResponse(message: ""))
        let interceptedResult = await sut.intercept(
            result: result,
            target: target,
            retryClosure: nil
        )
        XCTAssertFalse(mockActivityIndicator.isLoading)
        switch interceptedResult {
        case .success(let response):
            XCTAssertEqual(response.message, "")
        case .failure:
            XCTFail("Should not reach here")
        }
    }
}
