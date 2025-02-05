@testable import Administrator
import XCTest


final class TargetRequesterTests: XCTestCase {
    var mockHandlerProvider: MockHandlerProvider!
    var mockHandler: MockTargetHandler!
    var targetRequester: TargetRequester!

    override func setUp() {
        super.setUp()
        mockHandler = MockTargetHandler()
        mockHandlerProvider = MockHandlerProvider(mockHandler: mockHandler)
        targetRequester = TargetRequester(handlerProvider: mockHandlerProvider)
    }

    override func tearDown() {
        mockHandlerProvider = nil
        mockHandler = nil
        targetRequester = nil
        super.tearDown()
    }

    func testRequestHandledByCurrentHandler() async {
        let mockTarget = MockTarget()
        mockHandler.shouldHandle = true
        do {
            let response = try await targetRequester.request(target: mockTarget)
            XCTAssertEqual(response.statusCode, 200)
            XCTAssertNil(response.response)
        } catch {
            XCTFail("Expected success, but got an error: \(error)")
        }
    }

    func testRequestFailsWhenNoHandlerHandles() async {
        let mockTarget = MockTarget()
        mockHandler.shouldHandle = false
        do {
            _ = try await targetRequester.request(target: mockTarget)
            XCTFail("Expected failure, but got success.")
        } catch {
            // Assert
            XCTAssertTrue(error is ApiError)
            XCTAssertEqual(error as? ApiError, ApiError.unsupportedRequest)
        }
    }
}
