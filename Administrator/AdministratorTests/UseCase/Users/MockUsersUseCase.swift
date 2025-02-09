@testable import Administrator

final class MockUsersUseCase: UsersUseCaseType {
    var mockFetchUsersResult: Result<[User], Error> = .success([])
    var mockLoadMoreUsersResult: Result<[User], Error> = .success([])

    func fetchUsers() async -> Result<[User], Error> {
        mockFetchUsersResult
    }

    func loadMoreUsers() async -> Result<[User], Error> {
        mockLoadMoreUsersResult
    }
}
