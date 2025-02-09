import Foundation

final class AutomationTestUserDetailsUseCase: UserDetailsUseCaseType {
    private let result: Result<UserDetails, Error>

    init(result: Result<UserDetails, Error>) {
        self.result = result
    }

    func fetchUserDetails(loginUserName: String) async -> Result<UserDetails, Error> {
        result
    }
}

extension AutomationTestUserDetailsUseCase {
    static var success: AutomationTestUserDetailsUseCase {
        AutomationTestUserDetailsUseCase(result: .success(
            UserDetails(
                login: "jvantuyl",
                avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/101?v=4")!,
                blog: URL(string: "http://souja.net")!,
                location: "Plumas County, California, USA",
                followers: 63,
                following: 15
            )
        ))
    }

    static var failure: AutomationTestUserDetailsUseCase {
        AutomationTestUserDetailsUseCase(result: .failure(ApiError.unknown))
    }
}
