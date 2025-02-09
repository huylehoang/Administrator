import SwiftUI

final class UserDetailsCoordinator: Coordinator {
    private let loginUserName: String
    private let useCaseProvider: UserDetailsUseCaseProviderType
    private let navigationController: UINavigationController

    init(
        loginUserName: String,
        useCaseProvider: UserDetailsUseCaseProviderType = UserDetailsUseCaseProvider(),
        navigationController: UINavigationController
    ) {
        self.loginUserName = loginUserName
        self.useCaseProvider = useCaseProvider
        self.navigationController = navigationController
    }

    func start() {
        let useCase = useCaseProvider.makeUserDetailsUseCase()
        let viewModel = UserDetailsViewModel(loginUserName: loginUserName, useCase: useCase)
        let view = UserDetailsView(viewModel: viewModel, coordinator: self)
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }
}
