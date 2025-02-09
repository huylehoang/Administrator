import Foundation

final class AutomationTestUsersUseCase: UsersUseCaseType {
    private let fetchResult: Result<[User], Error>
    private let loadMoreResult: Result<[User], Error>

    init(fetchResult: Result<[User], Error>, loadMoreResult: Result<[User], Error>) {
        self.fetchResult = fetchResult
        self.loadMoreResult = loadMoreResult
    }

    func fetchUsers() async -> Result<[User], Error> {
        fetchResult
    }
    
    func loadMoreUsers() async -> Result<[User], Error> {
        loadMoreResult
    }
}

extension AutomationTestUsersUseCase {
    static var success: AutomationTestUsersUseCase {
        AutomationTestUsersUseCase(
            fetchResult: .success([
                User(
                    login: "jvantuyl",
                    avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/101?v=4")!,
                    htmlUrl: URL(string: "https://github.com/jvantuyl")!
                )
            ]),
            loadMoreResult: .success([
                User(
                    login: "jvantuyl",
                    avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/101?v=4")!,
                    htmlUrl: URL(string: "https://github.com/jvantuyl")!
                )
            ])
        )
    }

    static var empty: AutomationTestUsersUseCase {
        AutomationTestUsersUseCase(fetchResult: .success([]), loadMoreResult: .success([]))
    }

    static var failure: AutomationTestUsersUseCase {
        AutomationTestUsersUseCase(
            fetchResult: .failure(ApiError.unknown),
            loadMoreResult: .failure(ApiError.unknown)
        )
    }
}
