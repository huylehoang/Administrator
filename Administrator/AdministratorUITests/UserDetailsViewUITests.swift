import XCTest

final class UserDetailsViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testUserDetailsDisplay() throws {
        app.launchArguments = ["mock-success-response"]
        app.launch()
        let firstUser = app.images["image_jvantuyl"]
        XCTAssertTrue(firstUser.waitForExistence(timeout: 2))
        firstUser.tap()
        let detailsTitle = app.staticTexts["User Details"]
        XCTAssertTrue(detailsTitle.waitForExistence(timeout: 2))
        let locationLabel = app.staticTexts["Plumas County, California, USA"]
        XCTAssertTrue(locationLabel.waitForExistence(timeout: 2))
        let followersCount = app.staticTexts["63"]
        let followingCount = app.staticTexts["15"]
        XCTAssertTrue(followersCount.exists)
        XCTAssertTrue(followingCount.exists)
    }
}
