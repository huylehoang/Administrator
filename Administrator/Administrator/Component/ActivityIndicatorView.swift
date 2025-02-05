import SwiftUI
import Combine

struct ActivityIndicatorView: View {
    private let isLoadingPublisher: AnyPublisher<Bool, Never>
    @State private var isLoading = false

    init(
        isLoadingPublisher: AnyPublisher<Bool, Never> = ActivityIndicatorManager.shared.isLoading
    ) {
        self.isLoadingPublisher = isLoadingPublisher
    }

    var body: some View {
        ZStack {
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                ProgressView("Loading...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        }
        .onReceive(isLoadingPublisher) { isLoading in
            self.isLoading = isLoading
        }
        .animation(.easeInOut, value: isLoading)
    }
}
