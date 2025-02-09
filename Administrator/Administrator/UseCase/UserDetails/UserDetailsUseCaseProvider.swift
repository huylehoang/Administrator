import Foundation

protocol UserDetailsUseCaseProviderType {
    func makeUserDetailsUseCase() -> UserDetailsUseCaseType
}

final class UserDetailsUseCaseProvider: UserDetailsUseCaseProviderType {
    func makeUserDetailsUseCase() -> UserDetailsUseCaseType {
        UserDetailsUseCase()
    }
}
