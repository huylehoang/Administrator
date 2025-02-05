@testable import Administrator
import Foundation

final class MockRequester: TargetRequesterType {
    var error: Error?
    var response: Decodable?

    func request<T: TargetType>(target: T) async throws -> TargetResponse<T.DataType> {
        if let error {
            throw error
        }
        return TargetResponse(
            response: response as? T.DataType,
            data: Data("response data".utf8),
            statusCode: 200
        )
    }
}
