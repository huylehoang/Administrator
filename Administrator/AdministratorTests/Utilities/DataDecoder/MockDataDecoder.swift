@testable import Administrator
import Foundation

final class MockDataDecoder: DataDecoderType {
    var decodeResponse: Decodable?

    func decode<T: Decodable>(data: Data) throws -> T? {
        decodeResponse as? T
    }
}
