import XCTest
@testable import Administrator

final class UsersTargetTests: XCTestCase {
    var decoder: DataDecoderType!

    override func setUp() {
        super.setUp()
        decoder = DataDecoder()
    }

    override func tearDown() {
        decoder = nil
        super.tearDown()
    }


    func testInitialization() {
        let sinceValue = 100
        let target = UsersTarget(since: sinceValue)
        XCTAssertEqual(target.scheme, "https")
        XCTAssertEqual(target.host, "api.github.com")
        XCTAssertEqual(target.path, "/users")
        XCTAssertEqual(target.method, .get)
        XCTAssertEqual(target.parameters?["per_page"] as? Int, 20)
        XCTAssertEqual(target.parameters?["since"] as? Int, sinceValue)
        XCTAssertNil(target.body)
        XCTAssertNil(target.headers)
    }

    func testCreateRequest() throws {
        let target = UsersTarget(since: 100)
        let request = try target.createRequest()

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.httpBody)

        guard
            let url = request.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            XCTFail("Invalid URL")
            return
        }
        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "api.github.com")
        XCTAssertEqual(components.path, "/users")
        // Convert query items into a dictionary for unordered comparison
        let queryItemsDict = Dictionary(
            uniqueKeysWithValues: components.queryItems?.map { ($0.name, $0.value) } ?? []
        )
        let expectedQueryItems: [String: String] = ["per_page": "20", "since": "100"]
        XCTAssertEqual(queryItemsDict, expectedQueryItems)
    }

    func testUserDecoding() throws {
        let data = """
        {
            "id": 1,
            "login": "john_doe",
            "avatar_url": "https://example.com/avatar.png",
            "html_url": "https://example.com/profile"
        }
        """.data(using: .utf8)!
        let user: UsersTarget.DataType.Item? = try decoder.decode(data: data)
        XCTAssertEqual(user?.id, 1)
        XCTAssertEqual(user?.login, "john_doe")
        XCTAssertEqual(user?.avatarUrl, URL(string: "https://example.com/avatar.png"))
        XCTAssertEqual(user?.htmlUrl, URL(string: "https://example.com/profile"))
    }

    func testUsersDataTypeDecoding() throws {
        let data = """
        [
            {
                "id": 1,
                "login": "john_doe",
                "avatar_url": "https://example.com/avatar.png",
                "html_url": "https://example.com/profile"
            },
            {
                "id": 2,
                "login": "jane_doe",
                "avatar_url": "https://example.com/avatar2.png",
                "html_url": "https://example.com/profile2"
            }
        ]
        """.data(using: .utf8)!
        let usersData: UsersTarget.DataType? = try decoder.decode(data: data)
        XCTAssertEqual(usersData?.items.count, 2)
        XCTAssertEqual(usersData?.items[0].login, "john_doe")
        XCTAssertEqual(usersData?.items[1].login, "jane_doe")
    }

    func testUsersEquatable() {
        let user1 = UsersTarget.DataType.Item(
            id: 1,
            login: "user1",
            avatarUrl: URL(string: "https://example.com/avatar1.png")!,
            htmlUrl: URL(string: "https://example.com/profile1")!
        )
        let user2 = UsersTarget.DataType.Item(
            id: 2,
            login: "user2",
            avatarUrl: URL(string: "https://example.com/avatar2.png")!,
            htmlUrl: URL(string: "https://example.com/profile2")!
        )
        let user3 = UsersTarget.DataType.Item(
            id: 1,
            login: "user1",
            avatarUrl: URL(string: "https://example.com/avatar1.png")!,
            htmlUrl: URL(string: "https://example.com/profile1")!
        )
        XCTAssertEqual(user1, user3)
        XCTAssertNotEqual(user1, user2)
    }

    func testUsersDataTypeEquatable() {
        let user1 = UsersTarget.DataType.Item(
            id: 1,
            login: "user1",
            avatarUrl: URL(string: "https://example.com/avatar1.png")!,
            htmlUrl: URL(string: "https://example.com/profile1")!
        )
        let user2 = UsersTarget.DataType.Item(
            id: 2,
            login: "user2",
            avatarUrl: URL(string: "https://example.com/avatar2.png")!,
            htmlUrl: URL(string: "https://example.com/profile2")!
        )
        let data1 = UsersTarget.DataType(users: [user1, user2])
        let data2 = UsersTarget.DataType(users: [user1, user2])
        let data3 = UsersTarget.DataType(users: [user1])
        XCTAssertEqual(data1, data2)
        XCTAssertNotEqual(data1, data3)
    }

    func testUserDescription() {
        let user = UsersTarget.DataType.Item(
            id: 1,
            login: "user1",
            avatarUrl: URL(string: "https://example.com/avatar1.png")!,
            htmlUrl: URL(string: "https://example.com/profile1")!
        )
        let expectedDescription = """
        Item(id: 1, login: user1, avatarUrl: https://example.com/avatar1.png, \
        htmlUrl: https://example.com/profile1)
        """
        XCTAssertEqual(user.description, expectedDescription)
    }

    func testUsersDataTypeDescription() {
        let user1 = UsersTarget.DataType.Item(
            id: 1,
            login: "user1",
            avatarUrl: URL(string: "https://example.com/avatar1.png")!,
            htmlUrl: URL(string: "https://example.com/profile1")!
        )
        let user2 = UsersTarget.DataType.Item(
            id: 2,
            login: "user2",
            avatarUrl: URL(string: "https://example.com/avatar2.png")!,
            htmlUrl: URL(string: "https://example.com/profile2")!
        )
        let data = UsersTarget.DataType(users: [user1, user2])
        let expectedDescription = """
        DataType(items:
        Item(id: 1, login: user1, avatarUrl: https://example.com/avatar1.png, \
        htmlUrl: https://example.com/profile1),
        Item(id: 2, login: user2, avatarUrl: https://example.com/avatar2.png, \
        htmlUrl: https://example.com/profile2)
        )
        """
        XCTAssertEqual(data.description, expectedDescription)
    }
}
