import XCTest
@testable import Administrator

final class UsersViewModelTests: XCTestCase {

    var viewModel: UsersViewModel!
    var mockUseCase: MockUsersUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockUsersUseCase()
        viewModel = UsersViewModel(useCase: mockUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }

    func test_init_startsWithEmptyUsers() {
        XCTAssertTrue(viewModel.users.isEmpty, "Users should start empty")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil at initialization")
    }

    func test_loadUsers_success() async {
        let expectedUsers = [User(
            login: "testUser",
            avatarUrl: URL(string: "https://example.com")!,
            htmlUrl: URL(string: "https://github.com/testUser")!
        )]
        mockUseCase.mockFetchUsersResult = .success(expectedUsers)
        await viewModel.loadUsers()
        XCTAssertEqual(viewModel.users, expectedUsers)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_loadUsers_failure() async {
        mockUseCase.mockFetchUsersResult = .failure(ApiError.unknown)
        await viewModel.loadUsers()
        XCTAssertTrue(viewModel.users.isEmpty, "Users should remain empty on failure")
        XCTAssertEqual(viewModel.errorMessage, ApiError.unknown.localizedDescription)
    }

    func test_loadMoreUsers_success() async {
        let initialUsers = [User(
            login: "user1",
            avatarUrl: URL(string: "https://example.com")!,
            htmlUrl: URL(string: "https://github.com/user1")!
        )]
        let moreUsers = [User(
            login: "user2",
            avatarUrl: URL(string: "https://example.com")!,
            htmlUrl: URL(string: "https://github.com/user2")!
        )]
        mockUseCase.mockFetchUsersResult = .success(initialUsers)
        mockUseCase.mockLoadMoreUsersResult = .success(moreUsers)
        await viewModel.loadUsers()
        await viewModel.loadMoreUsers()
        XCTAssertEqual(viewModel.users, moreUsers)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_loadMoreUsers_failure() async {
        mockUseCase.mockLoadMoreUsersResult = .failure(ApiError.unknown)
        await viewModel.loadMoreUsers()
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, ApiError.unknown.localizedDescription)
    }
}
