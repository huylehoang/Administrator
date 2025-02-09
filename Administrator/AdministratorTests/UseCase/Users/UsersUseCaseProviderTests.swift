import XCTest
@testable import Administrator

final class UsersUseCaseProviderTests: XCTestCase {
    func test_makeUsersUseCase_returnsCorrectType() {
        let provider = UsersUseCaseProvider()
        let useCase = provider.makeUsersUseCase()
        XCTAssertTrue(useCase is UsersUseCase)
    }
}
