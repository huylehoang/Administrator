import UIKit

final class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    var popCalled = false

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
