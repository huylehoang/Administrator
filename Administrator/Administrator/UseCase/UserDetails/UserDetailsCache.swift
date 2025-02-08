import Foundation

protocol UserDetailsCacheType {
    func saveUserDetails(_ userDetails: UserDetailsTarget.DataType)
    func getUserDetails(for loginUserName: String) -> UserDetailsTarget.DataType?
}

final class UserDetailsCache: UserDetailsCacheType {
    private let storage: UserDefaults
    private let encoder: DataEncoderType
    private let decoder: DataDecoderType
    private let keyPrefix = "cached_user_details_"

    init(
        storage: UserDefaults = .standard,
        encoder: DataEncoderType = DataEncoder(),
        decoder: DataDecoderType = DataDecoder()
    ) {
        self.storage = storage
        self.encoder = encoder
        self.decoder = decoder
    }

    func saveUserDetails(_ userDetails: UserDetailsTarget.DataType) {
        let key = keyPrefix + userDetails.login
        if let data = try? encoder.encode(object: userDetails) {
            storage.setValue(data, forKey: key)
        }
    }

    func getUserDetails(for loginUserName: String) -> UserDetailsTarget.DataType? {
        let key = keyPrefix + loginUserName
        guard let data = storage.data(forKey: key) else {
            return nil
        }
        return try? decoder.decode(data: data)
    }
}
