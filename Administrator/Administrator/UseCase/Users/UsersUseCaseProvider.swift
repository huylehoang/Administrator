import Foundation

protocol UsersUseCaseProviderType {
    func makeUsersUseCase() -> UsersUseCaseType
}

final class UsersUseCaseProvider: UsersUseCaseProviderType {
    func makeUsersUseCase() -> UsersUseCaseType {
        UsersUseCase()
    }
}
