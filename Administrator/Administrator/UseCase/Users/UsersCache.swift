import Foundation

protocol UsersCacheType {
    func saveUsers(_ users: [UsersTarget.DataType.Item])
    func appendUsers(_ users: [UsersTarget.DataType.Item])
    func getUsers() -> [UsersTarget.DataType.Item]
    func getLastUserId() -> Int?
}

final class UsersCache: UsersCacheType {
    typealias User = UsersTarget.DataType.Item
    private let key: String
    private let storage: UserDefaults
    private let encoder: DataEncoderType
    private let decoder: DataDecoderType

    init(
        key: String = "cached_users",
        storage: UserDefaults = .standard,
        encoder: DataEncoderType = DataEncoder(),
        decoder: DataDecoderType = DataDecoder()
    ) {
        self.key = key
        self.storage = storage
        self.encoder = encoder
        self.decoder = decoder
    }

    func saveUsers(_ users: [User]) {
        if let data = try? encoder.encode(object: users) {
            storage.setValue(data, forKey: key)
        }
    }

    func appendUsers(_ users: [User]) {
        var cachedUsers = getUsers()
        cachedUsers.append(contentsOf: users)
        saveUsers(cachedUsers)
    }

    func getUsers() -> [User] {
        guard let data = storage.data(forKey: key) else {
            return []
        }
        do {
            return try decoder.decode(data: data) ?? []
        } catch {
            return []
        }
    }

    func getLastUserId() -> Int? {
        getUsers().last?.id
    }
}
