import XCTest
@testable import Administrator

final class UsersUseCaseProviderTests: XCTestCase {
    private var mockProcessInfo: MockProcessInfo!
    private var provider: UsersUseCaseProvider!

    override func setUp() {
        super.setUp()
        mockProcessInfo = MockProcessInfo()
        provider = UsersUseCaseProvider(processInfo: mockProcessInfo)
    }

    override func tearDown() {
        mockProcessInfo = nil
        provider = nil
        super.tearDown()
    }

    func test_makeUsersUseCase_returnsCorrectType() {
        let useCase = provider.makeUsersUseCase()
        XCTAssertTrue(useCase is UsersUseCase)
    }

    func test_makeUsersUseCase_successMock() {
        mockProcessInfo.arguments = ["mock-success-response"]
        let useCase = provider.makeUsersUseCase()
        XCTAssertTrue(useCase is AutomationTestUsersUseCase)
    }

    func test_makeUsersUseCase_failureMock() {
        mockProcessInfo.arguments = ["mock-error-response"]
        let useCase = provider.makeUsersUseCase()
        XCTAssertTrue(useCase is AutomationTestUsersUseCase)
    }

    func test_makeUsersUseCase_empty() {
        mockProcessInfo.environment = ["XCTestConfigurationFilePath": "/path/to/config"]
        let useCase = provider.makeUsersUseCase()
        XCTAssertTrue(useCase is AutomationTestUsersUseCase)
    }
}
