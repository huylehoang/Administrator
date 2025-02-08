import Combine

// MARK: - Main Actor Activity Indicator Manager
/// `ActivityIndicatorManager` is a singleton class conforming to `ActivityIndicatorType`.
/// - Manages the loading indicator's state in a thread-safe and SwiftUI-compatible manner.
/// - Leverages `@MainActor` to ensure UI updates occur on the main thread, preventing
/// race conditions.
final class ActivityIndicatorManager: ObservableObject, ActivityIndicatorType {
    static let shared = ActivityIndicatorManager()

    @Published private var isLoadingState = false

    var isLoading: AnyPublisher<Bool, Never> {
        $isLoadingState.eraseToAnyPublisher()
    }

    // Actor to handle thread-safe state management.
    private let state = State()

    private init() {}

    init(forTesting _: Void = ()) {}

    func show() async {
        await state.set(isLoading: true)
        await updatePublishedState()
    }

    func hide() async {
        await state.set(isLoading: false)
        await updatePublishedState()
    }
}

private extension ActivityIndicatorManager {
    actor State {
        var isLoading = false

        func set(isLoading: Bool) {
            self.isLoading = isLoading
        }
    }

    // MARK: - Helper to Sync Published State
    /// Updates the `@Published` state property to reflect the latest value from the actor.
    /// Ensures synchronization between the actor's state and the published state for SwiftUI.
    @MainActor
    func updatePublishedState() async {
        isLoadingState = await state.isLoading
    }
}
