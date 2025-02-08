import Foundation

protocol DataDecoderType {
    func decode<T: Decodable>(data: Data) throws -> T?
}

final class DataDecoder: DataDecoderType {
    private let decoder: JSONDecoder

    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    init(decoder: JSONDecoder = DataDecoder.defaultDecoder) {
        self.decoder = decoder
    }

    func decode<T: Decodable>(data: Data) throws -> T? {
        try? decoder.decode(T.self, from: data)
    }
}
