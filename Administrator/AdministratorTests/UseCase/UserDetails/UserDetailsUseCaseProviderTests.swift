import XCTest
@testable import Administrator

final class UserDetailsUseCaseProviderTests: XCTestCase {
    private var mockProcessInfo: MockProcessInfo!
    private var provider: UserDetailsUseCaseProvider!

    override func setUp() {
        super.setUp()
        mockProcessInfo = MockProcessInfo()
        provider = UserDetailsUseCaseProvider(processInfo: mockProcessInfo)
    }

    override func tearDown() {
        mockProcessInfo = nil
        provider = nil
        super.tearDown()
    }

    func test_makeUserDetailsUseCase_returnsCorrectType() {
        let useCase = provider.makeUserDetailsUseCase()
        XCTAssertTrue(useCase is UserDetailsUseCase)
    }

    func test_makeUsersUseCase_successMock() {
        mockProcessInfo.arguments = ["mock-success-response"]
        let useCase = provider.makeUserDetailsUseCase()
        XCTAssertTrue(useCase is AutomationTestUserDetailsUseCase)
    }

    func test_makeUsersUseCase_failureMock() {
        mockProcessInfo.arguments = ["mock-error-response"]
        let useCase = provider.makeUserDetailsUseCase()
        XCTAssertTrue(useCase is AutomationTestUserDetailsUseCase)
    }
}
