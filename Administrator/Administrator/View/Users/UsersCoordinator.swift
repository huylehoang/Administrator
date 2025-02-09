import SwiftUI

final class UsersCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let useCaseProvider: UsersUseCaseProviderType

    init(
        navigationController: UINavigationController,
        useCaseProvider: UsersUseCaseProviderType = UsersUseCaseProvider()
    ) {
        self.navigationController = navigationController
        self.useCaseProvider = useCaseProvider
    }

    func start() {
        let useCase = useCaseProvider.makeUsersUseCase()
        let viewModel = UsersViewModel(useCase: useCase)
        let view = UsersView(viewModel: viewModel, coordinator: self)
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }

    func navigateToDetails(loginUserName: String) {
        let coordinator = UserDetailsCoordinator(
            loginUserName: loginUserName,
            navigationController: navigationController
        )
        coordinator.start()
    }
}
