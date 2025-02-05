@testable import Administrator
import XCTest

final class ApiServiceTests: XCTestCase {
    var mockApiService: ApiService!
    var mockRequester: MockRequester!
    var mockInterceptor: MockInterceptor!

    override func setUp() {
        super.setUp()
        mockApiService = ApiService.shared
        mockRequester = MockRequester()
        mockInterceptor = MockInterceptor()
        mockApiService.set(requester: mockRequester)
        mockApiService.set(interceptorPipeline: mockInterceptor)
    }

    override func tearDown() {
        mockApiService = nil
        mockRequester = nil
        mockInterceptor = nil
        super.tearDown()
    }

    func testRequestSuccess() async {
        let mockTarget = MockTarget()
        mockRequester.response = MockResponse(message: "Success")
        let result = await mockApiService.request(target: mockTarget)
        switch result {
        case .success(let response):
            XCTAssertEqual(response.message, "Success")
        case .failure:
            XCTFail("Expected success, but got failure.")
        }
    }

    func testRequestFailureNoData() async {
        let mockTarget = MockTarget()
        let result = await mockApiService.request(target: mockTarget)
        switch result {
        case .success:
            XCTFail("Expected failure, but got success.")
        case .failure(let error):
            XCTAssertEqual(error as? ApiError, ApiError.noDataFound)
        }
    }

    func testRequestFailure() async {
        let mockTarget = MockTarget()
        mockRequester.error = ApiError.unknown
        let result = await mockApiService.request(target: mockTarget)
        switch result {
        case .success:
            XCTFail("Expected failure, but got success.")
        case .failure(let error):
            XCTAssertEqual(error as? ApiError, ApiError.unknown)
        }
    }

    func testRequestRetry_success() async {
        let mockTarget = MockTarget()
        mockRequester.response = MockResponse(message: "Success")
        mockInterceptor.shouldTriggerRetry = true
        let result = await mockApiService.request(target: mockTarget)
        switch result {
        case .success(let response):
            XCTAssertEqual(response.message, "Success")
        case .failure:
            XCTFail("Should not reach here")
        }
    }

    func testRequestRetry_noDataFound() async {
        let mockTarget = MockTarget()
        mockInterceptor.shouldTriggerRetry = true
        let result = await mockApiService.request(target: mockTarget)
        switch result {
        case .success:
            XCTFail("Should not reach here")
        case .failure(let error):
            XCTAssertEqual(error as? ApiError, ApiError.noDataFound)
        }
    }

    func testRequestRetry_failure() async {
        let mockTarget = MockTarget()
        mockRequester.error = ApiError.unknown
        mockInterceptor.shouldTriggerRetry = true
        let result = await mockApiService.request(target: mockTarget)
        switch result {
        case .success:
            XCTFail("Should not reach here")
        case .failure(let error):
            XCTAssertEqual(error as? ApiError, ApiError.unknown)
        }
    }
}

extension ApiServiceTests {
    final class MockInterceptor: InterceptorType {
        var shouldTriggerRetry = false
        var modifyRequesterResult: (() -> Void)?

        func intercept<T: TargetType>(
            result: Result<T.DataType, Error>,
            target: T,
            retryClosure: (() async throws -> Result<T.DataType, Error>)?
        ) async -> Result<T.DataType, Error> {
            if shouldTriggerRetry {
                do {
                    return try await retryClosure?() ?? result
                } catch {
                    return .failure(error)
                }
            }
            return result
        }
    }
}
