import Foundation

struct UserDetailsTarget: TargetType {
    var scheme = "https"
    var host = "api.github.com"
    var path = ""
    var method: HTTPMethod = .get
    var parameters: [String : Any]? = nil
    var body: HTTPBody? = nil
    var headers: [String : String]? = nil

    init(loginUserName: String) {
        path = "/users/\(loginUserName.lowercased())"
    }
}

extension UserDetailsTarget {
    struct DataType: Codable, Equatable, CustomStringConvertible {
        let login: String
        let avatarUrl: URL
        let htmlUrl: URL
        let location: String
        let followers: Int
        let following: Int

        var description: String {
            """
            Item(login: \(login), \
            avatarUrl: \(avatarUrl.absoluteString)) \
            htmlUrl: \(htmlUrl.absoluteString) \
            location: \(location) \
            followers: \(followers) \
            following: \(following)
            """
        }
    }
}
