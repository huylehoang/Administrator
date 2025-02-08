@testable import Administrator

final class MockUsersCache: UsersCacheType {
    typealias User = UsersTarget.DataType.Item

    var storedUsers: [User] = []

    func saveUsers(_ users: [User]) {
        storedUsers = users
    }

    func appendUsers(_ users: [User]) {
        storedUsers.append(contentsOf: users)
    }

    func getUsers() -> [User] {
        storedUsers
    }

    func getLastUserId() -> Int? {
        storedUsers.last?.id
    }
}
