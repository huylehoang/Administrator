import XCTest
@testable import Administrator

final class UserDetailsViewModelTests: XCTestCase {
    private var viewModel: UserDetailsViewModel!
    private var mockUseCase: MockUserDetailsUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockUserDetailsUseCase()
        viewModel = UserDetailsViewModel(loginUserName: "testUser", useCase: mockUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }

    func test_loadUserDetails_success() async {
        let expectedDetails = UserDetails(
            login: "jvantuyl",
            avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/101?v=4")!,
            blog: URL(string: "http://souja.net")!,
            location: "Plumas County, California, USA",
            followers: 63,
            following: 15
        )
        mockUseCase.result = .success(expectedDetails)
        await viewModel.loadUserDetails()
        XCTAssertEqual(viewModel.userDetails?.login, "jvantuyl")
        XCTAssertEqual(viewModel.userDetails?.followers, 63)
        XCTAssertEqual(viewModel.userDetails?.following, 15)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_loadUserDetails_failure() async {
        mockUseCase.result = .failure(ApiError.unknown)
        await viewModel.loadUserDetails()
        XCTAssertNil(viewModel.userDetails)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
