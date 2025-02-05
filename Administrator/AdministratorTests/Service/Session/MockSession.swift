@testable import Administrator
import Foundation

final class MockSession: Session {
    var request: URLRequest?
    var response: (Data, URLResponse)?
    var error: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.request = request
        if let error = error {
            throw error
        }
        guard let response = response else {
            throw URLError(.badServerResponse)
        }
        return response
    }
}
