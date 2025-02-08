import Foundation

protocol UsersUseCaseType {
    func fetchUsers() async -> Result<[User], Error>
    func loadMoreUsers() async -> Result<[User], Error>
}

final class UsersUseCase: UsersUseCaseType {
    private let apiService: ApiServiceType
    private let cache: UsersCacheType
    private var lastUserId: Int? // Tracks last fetched user ID for pagination

    init(apiService: ApiServiceType = ApiService.shared, cache: UsersCacheType = UsersCache()) {
        self.apiService = apiService
        self.cache = cache
        lastUserId = cache.getLastUserId() // Restore last user ID from cache
    }

    /// Fetches users from cache first; if empty, fetches from API.
    func fetchUsers() async -> Result<[User], Error> {
        let cachedUsers = cache.getUsers()
        if !cachedUsers.isEmpty {
            return .success(cachedUsers.users) // Return cached users
        }
        let target = UsersTarget(since: lastUserId ?? 100) // Default start ID
        let result = await apiService.request(target: target)
        switch result {
        case .success(let usersData):
            cache.saveUsers(usersData.items) // Save new users to cache
            lastUserId = usersData.items.last?.id
            return .success(usersData.items.users)
        case .failure(let error):
            return .failure(error) // Return API error
        }
    }

    /// Loads more users based on the last fetched user ID
    func loadMoreUsers() async -> Result<[User], Error> {
        guard let lastId = lastUserId else {
            return .success(cache.getUsers().users) // Return cached users if no last ID
        }
        let target = UsersTarget(since: lastId)
        let result = await apiService.request(target: target)
        switch result {
        case .success(let usersData):
            cache.appendUsers(usersData.items) // Append new users to cache
            lastUserId = usersData.items.last?.id
            return .success(cache.getUsers().users) // Return updated list from cache
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension [UsersTarget.DataType.Item] {
    var users: [User] {
        map { User(login: $0.login, avatarUrl: $0.avatarUrl, htmlUrl: $0.htmlUrl) }
    }
}
