import Foundation

protocol UserDetailsUseCaseType {
    func fetchUserDetails(loginUserName: String) async -> Result<UserDetails, Error>
}

final class UserDetailsUseCase: UserDetailsUseCaseType {
    private let apiService: ApiServiceType
    private let cache: UserDetailsCacheType

    init(
        apiService: ApiServiceType = ApiService.shared,
        cache: UserDetailsCacheType = UserDetailsCache()
    ) {
        self.apiService = apiService
        self.cache = cache
    }

    func fetchUserDetails(loginUserName: String) async -> Result<UserDetails, Error> {
        if let cachedData = cache.getUserDetails(for: loginUserName) {
            return .success(cachedData.userDetails)
        }
        let target = UserDetailsTarget(loginUserName: loginUserName)
        let result = await apiService.request(target: target)
        switch result {
        case .success(let data):
            cache.saveUserDetails(data)
            return .success(data.userDetails)
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension UserDetailsTarget.DataType {
    var userDetails: UserDetails {
        UserDetails(
            login: login,
            avatarUrl: avatarUrl,
            blog: blog,
            location: location,
            followers: followers,
            following: following
        )
    }
}
