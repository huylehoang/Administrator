import SwiftUI

struct UsersView: View {
    @ObservedObject private var viewModel: UsersViewModel
    private let coordinator: UsersCoordinator

    init(viewModel: UsersViewModel, coordinator: UsersCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users.indices, id: \.self) { index in
                    let user = viewModel.users[index]
                    UserRow(
                        user: user,
                        action: { 
                            coordinator.navigateToDetails(loginUserName: user.login)
                        }
                    )
                    .onViewDidLoad {
                        let thresholdIndex = Int(Double(viewModel.users.count) * 0.85)
                        if index == thresholdIndex {
                            Task {
                                await viewModel.loadMoreUsers()
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Github Users")
            .overlay(ActivityIndicatorView())
            .overlay(ErrorView(errorMessage: $viewModel.errorMessage))
            .onViewDidLoad {
                Task {
                    await viewModel.loadUsers()
                }
            }
        }
    }
}

// MARK: - User Row
struct UserRow: View {
    let user: User
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 12) {
                AsyncImageView(url: user.avatarUrl)
                    .frame(width: 66, height: 66)
                    .accessibilityIdentifier("image_\(user.login)")
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.login)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Link(destination: user.htmlUrl) {
                        Text(user.htmlUrl.absoluteString)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                Spacer()
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .contentShape(Rectangle())
    }
}
