import Foundation

final class UsersViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published var errorMessage: String?
    private let useCase: UsersUseCaseType

    init(useCase: UsersUseCaseType = UsersUseCase()) {
        self.useCase = useCase
    }

    /// Loads users with cache-first strategy
    @MainActor
    func loadUsers() async {
        let result = await useCase.fetchUsers()
        handleResult(result)
    }

    /// Loads more users for pagination
    @MainActor
    func loadMoreUsers() async {
        let result = await useCase.loadMoreUsers()
        handleResult(result)
    }
}

private extension UsersViewModel {
    /// Helper to process API results
    private func handleResult(_ result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            self.users = users
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}
