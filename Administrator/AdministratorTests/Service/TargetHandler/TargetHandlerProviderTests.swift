@testable import Administrator
import XCTest

final class TargetHandlerProviderTests: XCTestCase {
    func test_init_withDefaultHandler() {
        let provider = TargetHandlerProvider()
        XCTAssertTrue(provider.handler is StandardTargetHandler)
    }

    func test_updateHandlers() {
        let defaultHandler = MockDefaultTargetHandler()
        let handler1 = MockTargetHandler()
        let handler2 = MockTargetHandler()
        let provider = TargetHandlerProvider(
            defaultHandler: defaultHandler,
            handlers: [handler1, handler1, handler2]
        )
        XCTAssertTrue(provider.handler === handler1)
        XCTAssertTrue(handler1.next === handler2)
        XCTAssertTrue(handler2.next === defaultHandler)
    }

    func test_updateDefaultHandler() {
        let defaultHandler = MockDefaultTargetHandler()
        let newDefaultHandler = MockDefaultTargetHandler()
        let handler1 = MockTargetHandler()
        let provider = TargetHandlerProvider(defaultHandler: defaultHandler, handlers: [handler1])
        provider.updateDefaultdHandler(newDefaultHandler)
        XCTAssertTrue(provider.handler === handler1)
        XCTAssertTrue(handler1.next === newDefaultHandler)
        XCTAssertTrue(defaultHandler !== newDefaultHandler)
    }

    func test_addHandler() {
        let defaultHandler = MockDefaultTargetHandler()
        let newHandler = MockTargetHandler()
        let provider = TargetHandlerProvider(defaultHandler: defaultHandler)
        provider.addHandler(newHandler)
        XCTAssertTrue(provider.handler === newHandler)
        XCTAssertTrue(newHandler.next === defaultHandler)
    }

    func test_addHandler_ignoresDefaultHandler() {
        let defaultHandler = MockDefaultTargetHandler()
        let provider = TargetHandlerProvider(defaultHandler: defaultHandler)
        provider.addHandler(defaultHandler)
        XCTAssertTrue(provider.handler === defaultHandler)
        XCTAssertNil(defaultHandler.next)
    }

    func test_updateHandler_withEmptyHandlers() {
        let defaultHandler = MockTargetHandler()
        let provider = TargetHandlerProvider(defaultHandler: defaultHandler)
        provider.updateHandlers([])
        XCTAssertTrue(provider.handler === defaultHandler)
    }
}
