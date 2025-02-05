import Foundation

protocol DataDecoderType {
    func decode<T: Decodable>(data: Data) throws -> T?
}

final class DataDecoder: DataDecoderType {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func decode<T: Decodable>(data: Data) throws -> T? {
        try? decoder.decode(T.self, from: data)
    }
}
