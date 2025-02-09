import XCTest
@testable import Administrator

final class AutomationTestUserDetailsUseCaseTests: XCTestCase {
    func test_fetchUserDetails_success() async {
        let useCase = AutomationTestUserDetailsUseCase.success
        let result = await useCase.fetchUserDetails(loginUserName: "jvantuyl")
        guard case .success(let userDetails) = result else {
            return XCTFail("Expected success but got failure")
        }
        XCTAssertEqual(userDetails.login, "jvantuyl")
        XCTAssertEqual(
            userDetails.avatarUrl.absoluteString,
            "https://avatars.githubusercontent.com/u/101?v=4"
        )
        XCTAssertEqual(userDetails.blog.absoluteString, "http://souja.net")
        XCTAssertEqual(userDetails.location, "Plumas County, California, USA")
        XCTAssertEqual(userDetails.followers, 63)
        XCTAssertEqual(userDetails.following, 15)
    }

    func test_fetchUserDetails_failure() async {
        let useCase = AutomationTestUserDetailsUseCase.failure
        let result = await useCase.fetchUserDetails(loginUserName: "jvantuyl")
        guard case .failure(let error) = result else {
            return XCTFail("Expected failure but got success")
        }
        XCTAssertEqual(error as? ApiError, ApiError.unknown)
    }
}
