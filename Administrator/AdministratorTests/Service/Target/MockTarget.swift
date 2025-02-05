@testable import Administrator

// Mock TargetType implementation
struct MockTarget: TargetType {
    typealias DataType = MockResponse

    var scheme: String = "https"
    var host: String = "api.github.com"
    var path: String = "/users"
    var method: HTTPMethod = .get
    var parameters: [String: Any]? = nil
    var body: HTTPBody? = nil
    var headers: [String: String]? = nil
}
