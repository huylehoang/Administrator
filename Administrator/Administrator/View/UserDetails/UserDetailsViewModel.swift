import Foundation

final class UserDetailsViewModel: ObservableObject {
    @Published private(set) var userDetails: UserDetails?
    @Published var errorMessage: String?
    private let loginUserName: String
    private let useCase: UserDetailsUseCaseType

    init(loginUserName: String, useCase: UserDetailsUseCaseType = UserDetailsUseCase()) {
        self.loginUserName = loginUserName
        self.useCase = useCase
    }

    @MainActor
    func loadUserDetails() async {
        let result = await useCase.fetchUserDetails(loginUserName: loginUserName)
        switch result {
        case .success(let userDetails):
            self.userDetails = userDetails
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}
