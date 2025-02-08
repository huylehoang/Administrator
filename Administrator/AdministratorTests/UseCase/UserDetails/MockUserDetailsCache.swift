@testable import Administrator

final class MockUserDetailsCache: UserDetailsCacheType {
    var cachedUserDetails: UserDetailsTarget.DataType?
    var saveUserDetailsCalled = false

    func saveUserDetails(_ userDetails: UserDetailsTarget.DataType) {
        saveUserDetailsCalled = true
        cachedUserDetails = userDetails
    }

    func getUserDetails(for loginUserName: String) -> UserDetailsTarget.DataType? {
        cachedUserDetails
    }
}
