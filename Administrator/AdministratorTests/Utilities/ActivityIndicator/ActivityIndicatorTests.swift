@testable import Administrator
import XCTest
import Combine

@MainActor
final class ActivityIndicatorManagerTests: XCTestCase {
    private var manager: ActivityIndicatorManager!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        manager = ActivityIndicatorManager(forTesting: ())
        cancellables = []
    }

    override func tearDown() {
        manager = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        let expectation = XCTestExpectation(description: "Initial state should be false")
        manager.isLoading
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)
    }

    func testShowSetsIsLoadingToTrue() async {
        let expectation = XCTestExpectation(description: "State should update to true after show()")
        var receivedValues: [Bool] = []
        manager.isLoading
            .sink { isLoading in
                receivedValues.append(isLoading)
                if receivedValues.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        await manager.show()
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues, [false, true])
    }

    func testHideSetsIsLoadingToFalse() async {
        let expectation = XCTestExpectation(
            description: "State should update to false after hide()"
        )
        var receivedValues: [Bool] = []
        manager.isLoading
            .sink { isLoading in
                receivedValues.append(isLoading)
                if receivedValues.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        await manager.show()
        await manager.hide()
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues, [false, true, false])
    }
}
