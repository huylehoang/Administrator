import XCTest
@testable import Administrator

final class UserDetailsUseCaseTests: XCTestCase {
    private var useCase: UserDetailsUseCase!
    private var mockApiService: MockApiService!
    private var mockCache: MockUserDetailsCache!
    private let testUserDetailsTargetData = UserDetailsTarget.DataType(
        login: "testUser",
        avatarUrl: URL(string: "https://example.com/avatar.png")!,
        htmlUrl: URL(string: "https://example.com")!,
        location: "Test Location",
        followers: 100,
        following: 50
    )

    override func setUp() {
        super.setUp()
        mockApiService = MockApiService()
        mockCache = MockUserDetailsCache()
        useCase = UserDetailsUseCase(apiService: mockApiService, cache: mockCache)
    }

    override func tearDown() {
        useCase = nil
        mockApiService = nil
        mockCache = nil
        super.tearDown()
    }

    func test_fetchUserDetails_shouldReturnCachedData() async {
        mockCache.cachedUserDetails = testUserDetailsTargetData
        let result = await useCase.fetchUserDetails(loginUserName: "testUser")
        switch result {
        case .success(let userDetails):
            XCTAssertEqual(userDetails, testUserDetailsTargetData.userDetails)
        case .failure:
            XCTFail("Expected success but received failure")
        }
    }

    func test_fetchUserDetails_shouldFetchFromAPIAndCacheData() async {
        mockCache.cachedUserDetails = nil
        mockApiService.success = testUserDetailsTargetData
        let result = await useCase.fetchUserDetails(loginUserName: "testUser")
        switch result {
        case .success(let userDetails):
            XCTAssertEqual(userDetails, testUserDetailsTargetData.userDetails)
            XCTAssertTrue(mockCache.saveUserDetailsCalled)
        case .failure:
            XCTFail("Expected success but received failure")
        }
    }

    func test_fetchUserDetails_shouldReturnFailureWhenAPIFails() async {
        mockCache.cachedUserDetails = nil
        mockApiService.failure = ApiError.unknown
        let result = await useCase.fetchUserDetails(loginUserName: "testUser")
        switch result {
        case .success:
            XCTFail("Expected failure but received success")
        case .failure(let error):
            XCTAssertEqual(error as? ApiError, ApiError.unknown)
        }
    }
}
