@testable import Administrator

final class MockUserDetailsUseCase: UserDetailsUseCaseType {
    var result: Result<UserDetails, Error>?

    func fetchUserDetails(loginUserName: String) async -> Result<UserDetails, Error> {
        return result ?? .failure(ApiError.unknown)
    }
}
