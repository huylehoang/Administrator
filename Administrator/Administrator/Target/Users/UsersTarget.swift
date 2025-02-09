import Foundation

struct UsersTarget: TargetType {
    var scheme = "https"
    var host = "api.github.com"
    var path = "/users"
    var method: HTTPMethod = .get
    var parameters: [String : Any]?
    var body: HTTPBody? = nil
    var headers: [String : String]? = nil

    init(since: Int, perPage: Int = 20) {
        parameters = ["since": since, "per_page": perPage]
    }
}

extension UsersTarget {
    struct DataType: Decodable, Equatable, CustomStringConvertible {
        struct Item: Codable, Equatable, CustomStringConvertible {
            let id: Int
            let login: String
            let avatarUrl: URL
            let htmlUrl: URL

            var description: String {
                """
                Item(id: \(id), \
                login: \(login), \
                avatarUrl: \(avatarUrl.absoluteString), \
                htmlUrl: \(htmlUrl.absoluteString))
                """
            }
        }

        let items: [Item]

        var description: String {
            "DataType(items:\n" + items.map(\.description).joined(separator: ",\n") + "\n)"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            items = try container.decode([Item].self)
        }

        init(items: [Item]) {
            self.items = items
        }
    }
}
