import Foundation

protocol DataEncoderType {
    func encode<T: Encodable>(object: T) throws -> Data
}

final class DataEncoder: DataEncoderType {
    private let encoder: JSONEncoder

    static var defaultEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }

    init(encoder: JSONEncoder = DataEncoder.defaultEncoder) {
        self.encoder = encoder
    }

    func encode<T: Encodable>(object: T) throws -> Data {
        try encoder.encode(object)
    }
}
