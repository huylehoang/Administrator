@testable import Administrator
import XCTest

final class TargetHandlerTypeTests: XCTestCase {
    func test_handle_whenHandlerHandlesRequest() async throws {
        let handler = MockTargetHandler()
        handler.shouldHandle = true
        let target = MockTarget()
        let response = try await handler.handle(target: target)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertNotNil(response.data)
        XCTAssertNil(response.response)
    }

    func test_handle_whenNextHandlerHandlesRequest() async throws {
        let firstHandler = MockTargetHandler()
        let secondHandler = MockTargetHandler()
        firstHandler.setNext(secondHandler)
        secondHandler.shouldHandle = true
        let target = MockTarget()
        let response = try await firstHandler.handle(target: target)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertNotNil(response.data)
        XCTAssertNil(response.response)
    }

    func test_handle_whenNoHandlerHandlesRequest() async throws {
        let handler = MockTargetHandler()
        let target = MockTarget()
        do {
            _ = try await handler.handle(target: target)
            XCTFail("should not reach here")
        } catch {
            XCTAssertEqual(error as? ApiError, ApiError.unsupportedRequest)
        }
    }

    func test_setNext_returnsNextHandler() {
        let firstHandler = MockTargetHandler()
        let secondHandler = MockTargetHandler()
        let returnedHandler = firstHandler.setNext(secondHandler)
        XCTAssertTrue(firstHandler.next === secondHandler)
        XCTAssertTrue(returnedHandler === secondHandler)
    }

    func test_nextHandle_whenNextExists_callsNextHandler() async throws {
        let firstHandler = MockTargetHandler()
        let secondHandler = MockTargetHandler()
        firstHandler.setNext(secondHandler)
        secondHandler.shouldHandle = true
        let target = MockTarget()
        let response = try await firstHandler.nextHandle(target: target)
        XCTAssertEqual(response.statusCode, 200)
    }

    func test_defaultNextProperty_isNil() {
        let handler = MockDefaultTargetHandler()
        let nextHandler = handler.next
        XCTAssertNil(nextHandler)
    }

    func test_defaultNextProperty_cannotBeSet() {
        let handler = MockDefaultTargetHandler()
        let newHandler = MockDefaultTargetHandler()
        handler.next = newHandler
        XCTAssertNil(handler.next)
    }
}
