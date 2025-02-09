import XCTest

final class UsersViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testDisplaysMockResponse() {
        app.launchArguments = ["mock-success-response"]
        app.launch()
        let navigationTitle = app.staticTexts["Github Users"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 2))
        let firstUser = app.staticTexts["jvantuyl"]
        XCTAssertTrue(firstUser.waitForExistence(timeout: 3))
    }

    func testDisplaysErrorOverlay() {
        app.launchArguments = ["mock-error-response"]
        app.launch()
        let errorView = app.staticTexts["Error"]
        XCTAssertTrue(errorView.waitForExistence(timeout: 2))
        let dismissButton = app.buttons["Dismiss"]
        XCTAssertTrue(dismissButton.exists)
        dismissButton.tap()
        XCTAssertFalse(errorView.exists)
    }
}
