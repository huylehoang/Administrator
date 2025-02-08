import XCTest
@testable import Administrator

final class UsersCacheTests: XCTestCase {
    private var cache: UsersCache!
    private var mockStorage: UserDefaults!
    private var mockEncoder: DataEncoderType!
    private var mockDecoder: DataDecoderType!

    override func setUp() {
        super.setUp()
        mockStorage = UserDefaults(suiteName: "testCache")!
        mockStorage.removePersistentDomain(forName: "testCache")
        mockEncoder = DataEncoder()
        mockDecoder = DataDecoder()
        cache = UsersCache(storage: mockStorage, encoder: mockEncoder, decoder: mockDecoder)
    }

    override func tearDown() {
        mockStorage.removePersistentDomain(forName: "testCache") // Clean up storage
        super.tearDown()
    }

    func test_saveUsers_shouldStoreData() {
        let users = [mockUser(id: 1, login: "testUser1"), mockUser(id: 2, login: "testUser2")]
        cache.saveUsers(users)
        let storedData = mockStorage.data(forKey: "cached_users")
        XCTAssertNotNil(storedData)
        let decodedUsers: [UsersTarget.DataType.Item]? = try? mockDecoder.decode(data: storedData!)
        XCTAssertEqual(decodedUsers?.count, 2)
    }

    func test_appendUsers_shouldAppendToExistingCache() {
        let initialUsers = [mockUser(id: 1, login: "user1")]
        cache.saveUsers(initialUsers)
        let newUsers = [mockUser(id: 2, login: "user2")]
        cache.appendUsers(newUsers)
        let storedUsers = cache.getUsers()
        XCTAssertEqual(storedUsers.count, 2)
        XCTAssertEqual(storedUsers.last?.login, "user2")
    }

    func test_getUsers_shouldReturnStoredUsers() {
        let users = [mockUser(id: 1, login: "testUser")]
        cache.saveUsers(users)
        let retrievedUsers = cache.getUsers()
        XCTAssertEqual(retrievedUsers.count, 1)
        XCTAssertEqual(retrievedUsers.first?.login, "testUser")
    }

    func test_getUsers_shouldReturnEmptyArrayIfNoData() {
        let retrievedUsers = cache.getUsers()
        XCTAssertTrue(retrievedUsers.isEmpty)
    }

    func test_getUsers_shouldReturnEmptyArrayIfDecodingFails() {
        let invalidData = "invalid_json".data(using: .utf8)!
        mockStorage.setValue(invalidData, forKey: "cached_users")
        let retrievedUsers = cache.getUsers()
        XCTAssertTrue(retrievedUsers.isEmpty)
    }

    func test_getLastUserId_shouldReturnLastUserId() {
        let users = [mockUser(id: 1, login: "testUser"), mockUser(id: 100, login: "admin")]
        cache.saveUsers(users)
        let lastUserId = cache.getLastUserId()
        XCTAssertEqual(lastUserId, 100)
    }

    func test_getLastUserId_shouldReturnNilIfNoUsers() {
        let lastUserId = cache.getLastUserId()
        XCTAssertNil(lastUserId)
    }

    // Helper function to create mock users
    private func mockUser(id: Int, login: String) -> UsersTarget.DataType.Item {
        UsersTarget.DataType.Item(
            id: id,
            login: login,
            avatarUrl: URL(string: "https://example.com/avatar.png")!,
            htmlUrl: URL(string: "https://example.com")!
        )
    }
}
