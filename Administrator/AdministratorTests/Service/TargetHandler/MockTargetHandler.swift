@testable import Administrator
import Foundation

final class MockTargetHandler: TargetHandlerType {
    var next: TargetHandlerType?
    var shouldHandle: Bool = false

    func handle<T: TargetType>(target: T) async throws -> TargetResponse<T.DataType> {
        if shouldHandle {
            return TargetResponse<T.DataType>(
                response: nil,
                data: Data(),
                statusCode: 200
            )
        }
        return try await nextHandle(target: target)
    }
}

final class MockDefaultTargetHandler: TargetHandlerType {
    func handle<T: TargetType>(target: T) async throws -> TargetResponse<T.DataType> {
        throw ApiError.unsupportedRequest
    }
}
