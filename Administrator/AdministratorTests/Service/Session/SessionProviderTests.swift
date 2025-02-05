@testable import Administrator
import XCTest

final class SessionProviderTests: XCTestCase {
    func testSingletonBehavior() {
        let instance1 = SessionProvider.shared
        let instance2 = SessionProvider.shared
        XCTAssertTrue(instance1 === instance2)
    }

    func testSessionMethodReturnsURLSession() {
        // Ensure the session() method returns a valid URLSession
        let provider = SessionProvider.shared
        let session = provider.session()
        XCTAssertTrue(session is URLSession)
    }

    func testMockSessionConformance() async throws {
        let mockData = Data("mock response".utf8)
        let mockURL = URL(string: "https://example.com")!
        let mockResponse = HTTPURLResponse(
            url: mockURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let mockSession = MockSession()
        mockSession.response = (mockData, mockResponse)
        let provider = MockSessionProvider(mockSession: mockSession)
        let session = provider.session()
        let request = URLRequest(url: mockURL)
        let (data, response) = try await session.data(for: request)
        XCTAssertEqual(data, mockData)
        XCTAssertEqual(response.url, mockURL)
        XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
    }

    func testMockSessionHandlesError() async {
        let mockError = URLError(.notConnectedToInternet)
        let mockSession = MockSession()
        mockSession.error = mockError
        let provider = MockSessionProvider(mockSession: mockSession)
        let session = provider.session()
        let request = URLRequest(url: URL(string: "https://example.com")!)
        do {
            _ = try await session.data(for: request)
            XCTFail("Expected an error to be thrown, but none was.")
        } catch {
            // Assert
            XCTAssertEqual(error as? URLError, mockError)
        }
    }
}
