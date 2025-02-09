import XCTest
import SwiftUI
@testable import Administrator

final class AppCoordinatorTests: XCTestCase {
    var window: MockWindow!
    var navigationController: MockNavigationController!
    var appCoordinator: AppCoordinator!

    override func setUp() {
        super.setUp()
        window = MockWindow()
        navigationController = MockNavigationController()
        appCoordinator = AppCoordinator(window: window, navigationController: navigationController)
    }

    override func tearDown() {
        window = nil
        appCoordinator = nil
        super.tearDown()
    }

    func testStart() {
        XCTAssertFalse(window.didCallMakeKeyAndVisible)
        appCoordinator.start()
        XCTAssertNotNil(window.rootViewController)
        XCTAssertTrue(window.didCallMakeKeyAndVisible)
        let navigationController = window.rootViewController as? UINavigationController
        XCTAssertNotNil(navigationController)
        let hostingController = navigationController?.topViewController
        as? UIHostingController<UsersView>
        XCTAssertNotNil(hostingController)
    }
}
