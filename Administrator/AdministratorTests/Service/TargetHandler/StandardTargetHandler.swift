@testable import Administrator
import XCTest

final class StandardTargetHandlerTests: XCTestCase {
    private var mockSession: MockSession!
    private var mockSessionProvider: MockSessionProvider!
    private var mockDataDecoder: MockDataDecoder!
    private var sut: StandardTargetHandler!

    override func setUp() {
        super.setUp()
        mockSession = MockSession()
        mockSessionProvider = MockSessionProvider(mockSession: mockSession)
        mockDataDecoder = MockDataDecoder()
        sut = StandardTargetHandler(
            sessionProvider: mockSessionProvider,
            dataDecoder: mockDataDecoder
        )
    }

    override func tearDown() {
        mockSession = nil
        mockSessionProvider = nil
        mockDataDecoder = nil
        sut = nil
        super.tearDown()
    }

    func test_handle_successfulResponse() async throws {
        let mockTarget = MockTarget()
        let expectedData = Data("{\"message\":\"message\"}".utf8)
        let expectedResponse = HTTPURLResponse(
            url: URL(string: "https://mock.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        mockSession.response = (expectedData, expectedResponse)
        mockDataDecoder.decodeResponse = MockResponse(message: "message")
        let response = try await sut.handle(target: mockTarget)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.data, expectedData)
        XCTAssertEqual(response.response, MockResponse(message: "message"))
    }

    func test_handle_invalidURLResponse() async throws {
        let mockTarget = MockTarget()
        let invalidResponse = URLResponse(
            url: URL(string: "https://mock.com")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        mockSession.response = (Data(), invalidResponse)
        do {
            _ = try await sut.handle(target: mockTarget)
            XCTFail("should not reach here")
        } catch {
            XCTAssertEqual(error as? ApiError, .badServerResponse)
        }
    }

    func test_handle_decodingFailure() async throws {
        let mockTarget = MockTarget()
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mock.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        mockSession.response = (Data(), mockResponse)
        mockDataDecoder.decodeResponse = nil
        let response = try await sut.handle(target: mockTarget)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.data, Data())
        XCTAssertNil(response.response)
    }
}
