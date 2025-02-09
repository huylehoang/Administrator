import XCTest
@testable import Administrator

final class UserDetailsUseCaseProviderTests: XCTestCase {
    func test_makeUserDetailsUseCase_returnsCorrectType() {
        let provider = UserDetailsUseCaseProvider()
        let useCase = provider.makeUserDetailsUseCase()
        XCTAssertTrue(useCase is UserDetailsUseCase)
    }
}
