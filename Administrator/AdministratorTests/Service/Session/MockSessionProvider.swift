@testable import Administrator
import Foundation

final class MockSessionProvider: SessionProviderType {
    private let mockSession: MockSession

    init(mockSession: MockSession) {
        self.mockSession = mockSession
    }

    func session() -> Session {
        mockSession
    }
}
