@testable import Administrator
import XCTest

final class DataDecoderTests: XCTestCase {
    private var sut: DataDecoder!

    override func setUp() {
        super.setUp()
        sut = DataDecoder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_decode_withValidData() throws {
        let validJSON = """
        {
            "message": "message"
        }
        """.data(using: .utf8)!
        let response: MockResponse? = try sut.decode(data: validJSON)
        XCTAssertEqual(response?.message, "message")
    }

    func test_decode_withInvalidData() throws {
        let invalidJSON = "invalid json".data(using: .utf8)!
        let response: MockResponse? = try sut.decode(data: invalidJSON)
        XCTAssertNil(response)
    }

    func test_decode_withEmptyData() throws {
        let emptyData = Data()
        let response: MockResponse? = try sut.decode(data: emptyData)
        XCTAssertNil(response)
    }
}
