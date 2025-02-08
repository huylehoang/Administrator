import XCTest
@testable import Administrator

final class UserDetailsCacheTests: XCTestCase {
    private var cache: UserDetailsCache!
    private var mockStorage: UserDefaults!
    private var mockEncoder: DataEncoder!
    private var mockDecoder: DataDecoder!
    private let testUser = UserDetailsTarget.DataType(
        login: "testUser",
        avatarUrl: URL(string: "https://example.com/avatar.png")!,
        htmlUrl: URL(string: "https://example.com")!,
        location: "Test Location",
        followers: 100,
        following: 50
    )

    override func setUp() {
        super.setUp()
        mockStorage = UserDefaults(suiteName: "testCache")
        mockStorage.removePersistentDomain(forName: "testCache") // Reset UserDefaults
        mockEncoder = DataEncoder()
        mockDecoder = DataDecoder()
        cache = UserDetailsCache(storage: mockStorage, encoder: mockEncoder, decoder: mockDecoder)
    }

    override func tearDown() {
        cache = nil
        mockStorage.removePersistentDomain(forName: "testCache") // Cleanup
        mockStorage = nil
        super.tearDown()
    }

    func test_saveUserDetails_shouldStoreEncodedData() {
        cache.saveUserDetails(testUser)
        let storedData = mockStorage.data(forKey: "cached_user_details_testUser")
        XCTAssertNotNil(storedData)
    }

    func test_getUserDetails_shouldReturnDecodedData() {
        let encodedData = try? mockEncoder.encode(object: testUser)
        mockStorage.set(encodedData, forKey: "cached_user_details_testUser")
        let retrievedUser = cache.getUserDetails(for: "testUser")
        XCTAssertNotNil(retrievedUser)
        XCTAssertEqual(retrievedUser, testUser)
    }

    func test_getUserDetails_shouldReturnNilForMissingUser() {
        let retrievedUser = cache.getUserDetails(for: "unknownUser")
        XCTAssertNil(retrievedUser)
    }

    func test_getUserDetails_shouldReturnNilForInvalidData() {
        mockStorage.set(Data(), forKey: "cached_user_details_testUser") // Corrupt data
        let retrievedUser = cache.getUserDetails(for: "testUser")
        XCTAssertNil(retrievedUser)
    }
}
