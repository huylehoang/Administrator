import XCTest
import SwiftUI
@testable import Administrator

final class UsersCoordinatorTests: XCTestCase {
    var navigationController: MockNavigationController!
    var coordinator: UsersCoordinator!

    override func setUp() {
        super.setUp()
        navigationController = MockNavigationController()
        coordinator = UsersCoordinator(navigationController: navigationController)
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
        as? UIHostingController<UsersView>
        XCTAssertNotNil(hostingController)
    }

    func testNavigateToDetail() {
        coordinator.navigateToDetails(loginUserName: "loginUserName")
        let hostingController = navigationController.pushedViewController
        as? UIHostingController<UserDetailsView>
        XCTAssertNotNil(hostingController)
    }
}
