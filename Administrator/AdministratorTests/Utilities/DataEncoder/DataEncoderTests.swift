import XCTest
@testable import Administrator

final class DataEncoderTests: XCTestCase {
    private var encoder: DataEncoder!

    override func setUp() {
        super.setUp()
        encoder = DataEncoder()
    }

    override func tearDown() {
        encoder = nil
        super.tearDown()
    }

    struct TestModel: Codable, Equatable {
        let id: Int
        let fullName: String
        let isActive: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case fullName = "full_name"
            case isActive = "is_active"
        }
    }

    func test_encodeValidObject_shouldReturnData() throws {
        let testObject = TestModel(id: 1, fullName: "John Doe", isActive: true)
        let encodedData = try encoder.encode(object: testObject)
        XCTAssertNotNil(encodedData)
    }

    func test_encodeCustomEncoderSettings_shouldApplyCorrectly() throws {
        let customEncoder = JSONEncoder()
        customEncoder.outputFormatting = .sortedKeys
        let encoder = DataEncoder(encoder: customEncoder)
        let testObject = TestModel(id: 2, fullName: "Alice", isActive: false)
        let encodedData = try encoder.encode(object: testObject)
        XCTAssertNotNil(encodedData, "Encoded data should not be nil")
        let jsonString = String(data: encodedData, encoding: .utf8)
        XCTAssertNotNil(jsonString, "JSON string should not be nil")
        let expectedSortedJSONString = """
        {
          "full_name" : "Alice",
          "id" : 2,
          "is_active" : false
        }
        """.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let actualJSON = jsonString!
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: " ", with: "")
        XCTAssertEqual(actualJSON, expectedSortedJSONString)
    }
}
