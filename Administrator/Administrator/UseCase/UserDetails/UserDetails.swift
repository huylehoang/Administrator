import Foundation

struct UserDetails: Equatable {
    let login: String
    let avatarUrl: URL
    let blog: URL
    let location: String
    let followers: Int
    let following: Int
}
