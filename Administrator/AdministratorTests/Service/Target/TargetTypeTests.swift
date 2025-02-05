@testable import Administrator
import XCTest

final class TargetTypeTests: XCTestCase {
    func test_createRequest_withValidURL() throws {
        var target = MockTarget()
        target.parameters = ["since": 100]
        let request = try target.createRequest()
        XCTAssertEqual(
            request.url?.absoluteString,
            "https://api.github.com/users?since=100"
        )
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func test_createRequest_withInvalidURL() throws {
        var target = MockTarget()
        target.path = "posts"
        do {
            _ = try target.createRequest()
            XCTFail("should not reach here")
        } catch {
            XCTAssertEqual(error.localizedDescription, "Invalid URL")
        }
    }

    func test_encodeHeaders() throws {
        var target = MockTarget()
        target.headers = ["Authorization": "Bearer token", "Accept": "application/json"]
        let request = try target.createRequest()
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer token")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
    }

    func test_encodeBody_withParameters() throws {
        var target = MockTarget()
        target.method = .post
        target.body = .parameters(["title": "foo", "body": "bar", "userId": 1])
        let request = try target.createRequest()
        let bodyData = request.httpBody
        XCTAssertNotNil(bodyData)
        if let bodyData = bodyData {
            let json = try JSONSerialization.jsonObject(with: bodyData) as? [String: Any]
            XCTAssertEqual(json?["title"] as? String, "foo")
            XCTAssertEqual(json?["body"] as? String, "bar")
            XCTAssertEqual(json?["userId"] as? Int, 1)
        }
    }

    func test_encodeBody_withRawData() throws {
        var target = MockTarget()
        target.method = .post
        target.body = .data("{\"key\": \"value\"}".data(using: .utf8)!)
        let request = try target.createRequest()
        XCTAssertEqual(request.httpBody, "{\"key\": \"value\"}".data(using: .utf8))
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func test_setValue_forHeaderField() throws {
        var target = MockTarget()
        target.setValue("application/json", forHeaderField: "Content-Type")
        XCTAssertEqual(target.headers?["Content-Type"], "application/json")
    }

    func test_setValue_forParameterField() throws {
        var target = MockTarget()
        target.setValue("newValue", forParameterField: "existingKey")
        XCTAssertEqual(target.parameters?["existingKey"] as? String, "newValue")
    }

    func test_setValue_forBodyParameterField() throws {
        var target = MockTarget()
        target.setValue("newValue", forBodyParameterField: "key")
        if case let .parameters(parameters, _) = target.body {
            XCTAssertEqual(parameters["key"] as? String, "newValue")
        } else {
            XCTFail("Expected HTTPBody.parameters.")
        }
    }
}
