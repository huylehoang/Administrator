@testable import Administrator
import XCTest

final class InterceptorPipelineTests: XCTestCase {
    private var sut: InterceptorPipeline!
    private var mockInterceptor: MockDefaultInterceptor!

    override func setUp() {
        super.setUp()
        sut = InterceptorPipeline(interceptors: [])
        mockInterceptor = MockDefaultInterceptor()
    }

    override func tearDown() {
        sut = nil
        mockInterceptor = nil
        super.tearDown()
    }

    func testDefaultInterceptors() {
        sut = InterceptorPipeline()
        let interceptors = sut.interceptors
        XCTAssertTrue(interceptors[0] is LoggerInterceptor)
        XCTAssertTrue(interceptors[1] is ActivityIndicatorInterceptor)
    }

    func testAddInterceptor() {
        sut.add(interceptor: mockInterceptor)
        XCTAssertEqual(sut.interceptors.count, 1)
    }

    func testAddInterceptors() {
        sut.add(interceptors: [mockInterceptor, mockInterceptor])
        XCTAssertEqual(sut.interceptors.count, 1)
    }

    func testInterceptorPipelineInterceptTarget() async throws {
        sut.add(interceptor: mockInterceptor)
        let target = MockTarget()
        let interceptedTarget = try await sut.intercept(target: target)
        let request = try target.createRequest()
        let interceptedRequest = try interceptedTarget.createRequest()
        XCTAssertEqual(request, interceptedRequest)
    }

    func testInterceptorPipelineInterceptResponse() async throws {
        sut.add(interceptor: mockInterceptor)
        let target = MockTarget()
        let response = TargetResponse(
            response: MockResponse(message: ""),
            data: nil,
            statusCode: 200
        )
        let interceptedResponse = try await sut.intercept(response: response, target: target)
        XCTAssertEqual(response.response?.message, interceptedResponse.response?.message)
        XCTAssertEqual(response.data, interceptedResponse.data)
        XCTAssertEqual(response.statusCode, interceptedResponse.statusCode)
    }

    func testInterceptorPipelineInterceptResult() async throws {
        sut.add(interceptor: mockInterceptor)
        let target = MockTarget()
        let result: Result<MockResponse, Error> = .success(MockResponse(message: ""))
        let interceptedResult = await sut.intercept(
            result: result,
            target: target,
            retryClosure: nil
        )
        switch interceptedResult {
        case .success(let response):
            XCTAssertEqual(response.message, "")
        case .failure:
            XCTFail("Should not reach here")
        }
    }
}
