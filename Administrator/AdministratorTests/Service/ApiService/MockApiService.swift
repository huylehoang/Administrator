@testable import Administrator

final class MockApiService: ApiServiceType {
    var target: (any TargetType)?
    var success: Decodable?
    var failure: Error?

    func request<T: TargetType>(target: T) async -> Result<T.DataType, Error> {
        self.target = target
        if let success = success as? T.DataType {
            return .success(success)
        }
        if let failure {
            return .failure(failure)
        }
        return .failure(ApiError.unknown)
    }
}
