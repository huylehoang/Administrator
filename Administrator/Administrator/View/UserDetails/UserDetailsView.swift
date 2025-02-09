import SwiftUI

struct UserDetailsView: View {
    @ObservedObject private var viewModel: UserDetailsViewModel
    private let coordinator: UserDetailsCoordinator

    init(viewModel: UserDetailsViewModel, coordinator: UserDetailsCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let user = viewModel.userDetails {
                        UserInfoCard(user: user)
                        FollowSection(user: user)
                        BlogSection(user: user)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("User Details")
        }
        .overlay(ActivityIndicatorView())
        .overlay(ErrorView(errorMessage: $viewModel.errorMessage))
        .onViewDidLoad {
            Task {
                await viewModel.loadUserDetails()
            }
        }
    }
}

// MARK: - User Info Card
struct UserInfoCard: View {
    let user: UserDetails

    var body: some View {
        HStack(spacing: 16) {
            AsyncImageView(url: user.avatarUrl)
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 6) {
                Text(user.login)
                    .font(.title2)
                    .fontWeight(.bold)
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                    Text(user.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Follower & Following Section
struct FollowSection: View {
    let user: UserDetails

    var body: some View {
        HStack {
            Spacer()
            FollowInfo(icon: "person.2.fill", count: user.followers, label: "Followers")
            Spacer(minLength: 40)
            FollowInfo(icon: "person.fill.checkmark", count: user.following, label: "Following")
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

struct FollowInfo: View {
    let icon: String
    let count: Int
    let label: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text("\(count)")
                .font(.headline)
                .fontWeight(.bold)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Blog Section
struct BlogSection: View {
    let user: UserDetails

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Blog")
                .font(.headline)
            Link(destination: user.blog) {
                Text(user.blog.absoluteString)
                    .foregroundColor(.blue)
                    .underline()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}
