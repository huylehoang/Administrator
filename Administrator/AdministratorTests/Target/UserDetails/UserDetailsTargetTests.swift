import XCTest
@testable import Administrator

final class UserDetailsTargetTests: XCTestCase {
    private var decoder: DataDecoderType!

    override func setUp() {
        super.setUp()
        decoder = DataDecoder()
    }

    override func tearDown() {
        decoder = nil
        super.tearDown()
    }

    func testUserTargetInitialization() {
        let target = UserDetailsTarget(loginUserName: "octocat")
        XCTAssertEqual(target.path, "/users/octocat")
        XCTAssertEqual(target.scheme, "https")
        XCTAssertEqual(target.host, "api.github.com")
        XCTAssertEqual(target.method, .get)
        XCTAssertNil(target.parameters)
        XCTAssertNil(target.body)
        XCTAssertNil(target.headers)
    }

    func testUserTargetCreateRequest() throws {
        let target = UserDetailsTarget(loginUserName: "octocat")
        let request = try target.createRequest()
        XCTAssertEqual(request.url?.absoluteString, "https://api.github.com/users/octocat")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.allHTTPHeaderFields, [:])
        XCTAssertNil(request.httpBody)
    }

    func testDecodingUserTargetDataType() throws {
        let json = """
        {
            "login": "octocat",
            "avatar_url": "https://github.com/images/error/octocat_happy.gif",
            "blog": "https://github.com/octocat",
            "location": "San Francisco",
            "followers": 100,
            "following": 50
        }
        """.data(using: .utf8)!
        let decoded: UserDetailsTarget.DataType? = try decoder.decode(data: json)
        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded?.login, "octocat")
        XCTAssertEqual(
            decoded?.avatarUrl.absoluteString,
            "https://github.com/images/error/octocat_happy.gif"
        )
        XCTAssertEqual(decoded?.blog.absoluteString, "https://github.com/octocat")
        XCTAssertEqual(decoded?.location, "San Francisco")
        XCTAssertEqual(decoded?.followers, 100)
        XCTAssertEqual(decoded?.following, 50)
    }

    func testUserTargetDataTypeEquatable() {
        let user1 = UserDetailsTarget.DataType(
            login: "octocat",
            avatarUrl: URL(string: "https://github.com/octocat.png")!,
            blog: URL(string: "https://github.com/octocat")!,
            location: "San Francisco",
            followers: 100,
            following: 50
        )
        let user2 = UserDetailsTarget.DataType(
            login: "octocat",
            avatarUrl: URL(string: "https://github.com/octocat.png")!,
            blog: URL(string: "https://github.com/octocat")!,
            location: "San Francisco",
            followers: 100,
            following: 50
        )
        let user3 = UserDetailsTarget.DataType(
            login: "not-octocat",
            avatarUrl: URL(string: "https://github.com/not-octocat.png")!,
            blog: URL(string: "https://github.com/not-octocat")!,
            location: "New York",
            followers: 10,
            following: 5
        )
        XCTAssertEqual(user1, user2)
        XCTAssertNotEqual(user1, user3)
    }
}
