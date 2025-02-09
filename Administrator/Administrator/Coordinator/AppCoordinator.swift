import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let coordinator = UsersCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
