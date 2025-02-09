import Foundation

protocol UserDetailsUseCaseProviderType {
    func makeUserDetailsUseCase() -> UserDetailsUseCaseType
}

final class UserDetailsUseCaseProvider: UserDetailsUseCaseProviderType {
    private let processInfo: ProcessInfoType

    init(processInfo: ProcessInfoType = ProcessInfo.processInfo) {
        self.processInfo = processInfo
    }

    func makeUserDetailsUseCase() -> UserDetailsUseCaseType {
        if processInfo.arguments.contains("mock-success-response") ||
            processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return AutomationTestUserDetailsUseCase.success
        }
        if processInfo.arguments.contains("mock-error-response") {
            return AutomationTestUserDetailsUseCase.failure
        }
        return UserDetailsUseCase()
    }
}
