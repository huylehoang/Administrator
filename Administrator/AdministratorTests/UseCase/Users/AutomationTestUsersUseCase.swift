import XCTest
@testable import Administrator

final class AutomationTestUsersUseCaseTests: XCTestCase {
    func test_fetchUsers_success() async {
        let useCase = AutomationTestUsersUseCase.success
        let result = await useCase.fetchUsers()
        guard case .success(let users) = result else {
            return XCTFail("Expected success but got failure")
        }
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users[0].login, "jvantuyl")
    }

    func test_loadMoreUsers_success() async {
        let useCase = AutomationTestUsersUseCase.success
        let result = await useCase.loadMoreUsers()
        guard case .success(let users) = result else {
            return XCTFail("Expected success but got failure")
        }
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users[0].login, "jvantuyl")
    }

    func test_fetchUsers_empty() async {
        let useCase = AutomationTestUsersUseCase.empty
        let result = await useCase.fetchUsers()
        guard case .success(let users) = result else {
            return XCTFail("Expected success but got failure")
        }
        XCTAssertTrue(users.isEmpty)
    }

    func test_loadMoreUsers_empty() async {
        let useCase = AutomationTestUsersUseCase.empty
        let result = await useCase.loadMoreUsers()
        guard case .success(let users) = result else {
            return XCTFail("Expected success but got failure")
        }
        XCTAssertTrue(users.isEmpty)
    }

    func test_fetchUsers_failure() async {
        let useCase = AutomationTestUsersUseCase.failure
        let result = await useCase.fetchUsers()
        guard case .failure(let error) = result else {
            return XCTFail("Expected failure but got success")
        }
        XCTAssertEqual(error as? ApiError, ApiError.unknown)
    }

    func test_loadMoreUsers_failure() async {
        let useCase = AutomationTestUsersUseCase.failure
        let result = await useCase.loadMoreUsers()
        guard case .failure(let error) = result else {
            return XCTFail("Expected failure but got success")
        }
        XCTAssertEqual(error as? ApiError, ApiError.unknown)
    }
}
