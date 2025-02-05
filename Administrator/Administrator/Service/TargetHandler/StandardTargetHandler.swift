import Foundation

final class StandardTargetHandler: TargetHandlerType {
    private let sessionProvider: SessionProviderType
    private let dataDecoder: DataDecoderType

    init(
        sessionProvider: SessionProviderType = SessionProvider.shared,
        dataDecoder: DataDecoderType = DataDecoder()
    ) {
        self.sessionProvider = sessionProvider
        self.dataDecoder = dataDecoder
    }

    func handle<T: TargetType>(target: T) async throws -> TargetResponse<T.DataType> {
        let request = try target.createRequest()
        let session = sessionProvider.session()
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw ApiError.badServerResponse
        }
        return TargetResponse(
            response: try dataDecoder.decode(data: data),
            data: data,
            statusCode: response.statusCode
        )
    }
}
