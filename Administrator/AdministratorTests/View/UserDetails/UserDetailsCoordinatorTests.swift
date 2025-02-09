import XCTest
import SwiftUI
@testable import Administrator

final class UserDetailsCoordinatorTests: XCTestCase {
    var navigationController: MockNavigationController!
    var coordinator: UserDetailsCoordinator!

    override func setUp() {
        super.setUp()
        navigationController = MockNavigationController()
        coordinator = UserDetailsCoordinator(
            loginUserName: "loginUserName",
            navigationController: navigationController
        )
    }

    override func tearDown() {
        navigationController = nil
        coordinator = nil
        super.tearDown()
    }

    func testStart() {
        XCTAssertNil(navigationController.pushedViewController)
        coordinator.start()
        let hostingController = navigationController.pushedViewController
        as? UIHostingController<UserDetailsView>
        XCTAssertNotNil(hostingController)
    }
}
