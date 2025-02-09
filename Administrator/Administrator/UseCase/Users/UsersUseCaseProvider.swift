import Foundation

protocol UsersUseCaseProviderType {
    func makeUsersUseCase() -> UsersUseCaseType
}

final class UsersUseCaseProvider: UsersUseCaseProviderType {
    private let processInfo: ProcessInfoType

    init(processInfo: ProcessInfoType = ProcessInfo.processInfo) {
        self.processInfo = processInfo
    }

    func makeUsersUseCase() -> UsersUseCaseType {
        if processInfo.arguments.contains("mock-success-response") {
            return AutomationTestUsersUseCase.success
        }
        if processInfo.arguments.contains("mock-error-response") {
            return AutomationTestUsersUseCase.failure
        }
        if processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return AutomationTestUsersUseCase.empty
        }
        return UsersUseCase()
    }
}
