import Foundation

protocol Session {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: Session {}

protocol SessionProviderType {
    func session() -> Session
}

final class SessionProvider: SessionProviderType {
    static let shared = SessionProvider()

    private let urlSession: URLSession

    // Private initializer to prevent direct instantiation
    private init() {
        urlSession = URLSession(configuration: .default)
    }

    func session() -> Session {
        urlSession
    }
}
