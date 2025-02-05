@testable import Administrator

final class MockHandlerProvider: TargetHandlerProviderType {
    var handler: TargetHandlerType

    init(mockHandler: TargetHandlerType) {
        handler = mockHandler
    }
}
