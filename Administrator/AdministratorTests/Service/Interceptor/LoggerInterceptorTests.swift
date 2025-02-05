@testable import Administrator
import XCTest

final class LoggerInterceptorTests: XCTestCase {
    private var capturedLog: String!
    private var mockDateProvider: MockDateProvider!
    private var sut: LoggerInterceptor!

    override func setUp() {
        super.setUp()
        capturedLog = ""
        mockDateProvider = MockDateProvider()
        // Fixed date for deterministic logs
        mockDateProvider.date = Date(timeIntervalSince1970: 1690000000)
        sut = LoggerInterceptor(
            logClosure: { [weak self] in self?.capturedLog = $0 },
            dateProvider: mockDateProvider
        )
    }

    override func tearDown() {
        sut = nil
        mockDateProvider = nil
        capturedLog = nil
        super.tearDown()
    }

    func testInterceptTarget_shouldLogCorrectString() async throws {
        let target = MockTarget()
        let expectedLog = """
        - [DEBUG] [22-07-2023 12:26:40] [MockTarget]: --- Target Debug ---
        --------> Method: GET
        --------> Parameters: None
        --------> Request: https://api.github.com/users
        --------> Headers: [:]
        --------> Body: None
        ---------------------------------------------------------------
        """
        _ = try await sut.intercept(target: target)
        XCTAssertEqual(capturedLog, expectedLog)
    }

    func testInterceptTarget_withParametersAndBody_shouldLogCorrectString() async throws {
        var target = MockTarget()
        target.parameters = ["key": "value"]
        target.body = .parameters(["key": "value"])
        let expectedLog = """
        - [DEBUG] [22-07-2023 12:26:40] [MockTarget]: --- Target Debug ---
        --------> Method: GET
        --------> Parameters: ["key": "value"]
        --------> Request: https://api.github.com/users?key=value
        --------> Headers: ["Content-Type": "application/json"]
        --------> Body: ["key": value]
        ---------------------------------------------------------------
        """
        _ = try await sut.intercept(target: target)
        XCTAssertEqual(capturedLog, expectedLog)
    }

    func testInterceptResponse_shouldLogCorrectString() async throws {
        let target = MockTarget()
        let response = TargetResponse<MockResponse>(
            response: MockResponse(message: ""),
            data: Data("response data".utf8),
            statusCode: 200
        )
        let expectedLog = """
        - [DEBUG] [22-07-2023 12:26:40] [MockTarget]: --- Response Debug ---
        --------> StatusCode: 200
        --------> Data: 13 bytes
        --------> Response: MockResponse(message: "")
        ---------------------------------------------------------------
        """
        _ = try await sut.intercept(response: response, target: target)
        XCTAssertEqual(capturedLog, expectedLog)
    }

    func testInterceptResponse_noResponseAndData_shouldLogCorrectString() async throws {
        let target = MockTarget()
        let response = TargetResponse<MockResponse>(statusCode: 200)
        let expectedLog = """
        - [DEBUG] [22-07-2023 12:26:40] [MockTarget]: --- Response Debug ---
        --------> StatusCode: 200
        --------> Data: None
        --------> Response: None
        ---------------------------------------------------------------
        """
        _ = try await sut.intercept(response: response, target: target)
        XCTAssertEqual(capturedLog, expectedLog)
    }

    func testInterceptResult_shouldLogCorrectStringForSuccess() async {
        let target = MockTarget()
        let result: Result<MockResponse, Error> = .success(MockResponse(message: "Success"))
        let expectedLog = """
        - [DEBUG] [22-07-2023 12:26:40] [MockTarget]: --- Result Success Debug ---
        --------> Success
        ---------------------------------------------------------------
        """
        _ = await sut.intercept(result: result, target: target, retryClosure: nil)
        XCTAssertEqual(capturedLog, expectedLog)
    }

    func testInterceptResult_shouldLogCorrectStringForFailure() async {
        let target = MockTarget()
        let error = ApiError.unknown
        let result: Result<MockResponse, Error> = .failure(error)
        let expectedLog = """
        - [DEBUG] [22-07-2023 12:26:40] [MockTarget]: --- Result Error Debug ---
        --------> Error: Something Went Wrong!!!
        ---------------------------------------------------------------
        """
        _ = await sut.intercept(result: result, target: target, retryClosure: nil)
        XCTAssertEqual(capturedLog, expectedLog)
    }
}
