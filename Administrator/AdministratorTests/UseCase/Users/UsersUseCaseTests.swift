import XCTest
@testable import Administrator

final class UsersUseCaseTests: XCTestCase {
    private var useCase: UsersUseCase!
    private var mockApiService: MockApiService!
    private var mockCache: MockUsersCache!

    override func setUp() {
        super.setUp()
        mockApiService = MockApiService()
        mockCache = MockUsersCache()
        useCase = UsersUseCase(apiService: mockApiService, cache: mockCache)
    }

    override func tearDown() {
        useCase = nil
        mockApiService = nil
        mockCache = nil
        super.tearDown()
    }

    func test_fetchUsers_withoutCache_shouldFetchFromAPI() async {
        let expectedUsers = mockUsers()
        mockApiService.success = UsersTarget.DataType(users: expectedUsers)
        let result = await useCase.fetchUsers()
        switch result {
        case .success(let users):
            XCTAssertEqual(users, expectedUsers.users)
            XCTAssertEqual(mockCache.getUsers(), expectedUsers)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }

    func test_fetchUsers_withCache_shouldReturnCachedUsers() async {
        let cachedUsers = mockUsers()
        mockCache.saveUsers(cachedUsers)
        let result = await useCase.fetchUsers()
        switch result {
        case .success(let users):
            XCTAssertEqual(users, cachedUsers.users)
            XCTAssertNil(mockApiService.target)
        case .failure:
            XCTFail("Expected cached users but got failure")
        }
    }

    func test_fetchUsers_apiFailure_shouldReturnError() async {
        mockApiService.failure = ApiError.unknown
        let result = await useCase.fetchUsers()
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error as? ApiError, ApiError.unknown)
        }
    }

    func test_loadMoreUsers_shouldFetchFromAPI() async {
        let cachedUsers = mockUsers()
        let newUsers = mockUsers(startingId: cachedUsers.last?.id ?? 1 + 1)
        mockCache.saveUsers(cachedUsers)
        mockApiService.success = UsersTarget.DataType(users: newUsers)
        useCase = UsersUseCase(apiService: mockApiService, cache: mockCache)
        let result = await useCase.loadMoreUsers()
        switch result {
        case .success(let users):
            XCTAssertEqual(users, (cachedUsers + newUsers).users)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }

    func test_loadMoreUsers_withoutLastUserId_shouldReturnCachedUsers() async {
        let cachedUsers = mockUsers()
        mockCache.saveUsers(cachedUsers)
        let result = await useCase.loadMoreUsers()
        switch result {
        case .success(let users):
            XCTAssertEqual(users, cachedUsers.users)
        case .failure:
            XCTFail("Expected cached users but got failure")
        }
    }

    func test_loadMoreUsers_apiFailure_shouldReturnCachedUsers() async {
        let cachedUsers = mockUsers()
        mockCache.saveUsers(cachedUsers)
        mockApiService.failure = ApiError.unknown
        useCase = UsersUseCase(apiService: mockApiService, cache: mockCache)
        let result = await useCase.loadMoreUsers()
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error as? ApiError, ApiError.unknown)
        }
    }

    private func mockUsers(count: Int = 3, startingId: Int = 1) -> [UsersTarget.DataType.Item] {
        return (startingId..<(startingId + count)).map {
            UsersTarget.DataType.Item(
                id: $0,
                login: "user\($0)",
                avatarUrl: URL(string: "https://example.com/avatar\($0).png")!,
                htmlUrl: URL(string: "https://example.com/user\($0)")!
            )
        }
    }
}
