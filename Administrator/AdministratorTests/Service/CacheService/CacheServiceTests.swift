@testable import Administrator
import XCTest

final class CacheServiceTests: XCTestCase {
    private var cache: CacheService<String, String>!

    override func setUp() {
        super.setUp()
        cache = CacheService<String, String>(countLimit: 3, totalCostLimit: 100)
    }

    override func tearDown() {
        cache = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertNil(cache.object(forKey: "nonexistent"))
    }

    func testSetAndRetrieveObject() {
        cache.setObject("Value1", forKey: "Key1")
        let retrievedValue = cache.object(forKey: "Key1")
        XCTAssertEqual(retrievedValue, "Value1")
    }

    func testOverwriteValueForKey() {
        cache.setObject("InitialValue", forKey: "Key1")
        cache.setObject("UpdatedValue", forKey: "Key1")
        let retrievedValue = cache.object(forKey: "Key1")
        XCTAssertEqual(retrievedValue, "UpdatedValue")
    }

    func testClearCache() {
        cache.setObject("Value1", forKey: "Key1")
        cache.setObject("Value2", forKey: "Key2")
        cache.clear()
        XCTAssertNil(cache.object(forKey: "Key1"))
        XCTAssertNil(cache.object(forKey: "Key2"))
    }

    func testEvictionByCountLimit() {
        cache.setObject("Value1", forKey: "Key1")
        cache.setObject("Value2", forKey: "Key2")
        cache.setObject("Value3", forKey: "Key3")
        cache.setObject("Value4", forKey: "Key4")
        XCTAssertNil(cache.object(forKey: "Key1"))
        XCTAssertEqual(cache.object(forKey: "Key2"), "Value2")
        XCTAssertEqual(cache.object(forKey: "Key4"), "Value4")
    }

    func testCustomObjectCaching() {
        struct CustomObject: Equatable {
            let id: Int
            let name: String
        }
        let customCache = CacheService<Int, CustomObject>()
        let object1 = CustomObject(id: 1, name: "Object1")
        let object2 = CustomObject(id: 2, name: "Object2")
        customCache.setObject(object1, forKey: 1)
        customCache.setObject(object2, forKey: 2)
        XCTAssertEqual(customCache.object(forKey: 1), object1)
        XCTAssertEqual(customCache.object(forKey: 2), object2)
    }

    func testDifferentKeyTypes() {
        let intCache = CacheService<Int, String>()
        intCache.setObject("Value1", forKey: 1)
        XCTAssertEqual(intCache.object(forKey: 1), "Value1")
        let uuidCache = CacheService<UUID, String>()
        let uuidKey = UUID()
        uuidCache.setObject("Value2", forKey: uuidKey)
        XCTAssertEqual(uuidCache.object(forKey: uuidKey), "Value2")
    }

    func testEvictionOrderWithRepeatedAccess() {
        cache.setObject("Value1", forKey: "Key1")
        cache.setObject("Value2", forKey: "Key2")
        cache.setObject("Value3", forKey: "Key3")
        _ = cache.object(forKey: "Key1")
        cache.setObject("Value4", forKey: "Key4")
        XCTAssertNil(cache.object(forKey: "Key2"))
        XCTAssertEqual(cache.object(forKey: "Key1"), "Value1")
        XCTAssertEqual(cache.object(forKey: "Key4"), "Value4")
    }

    func testMemoryCostLimit() {
        let smallCache = CacheService<String, String>(countLimit: 1, totalCostLimit: 5)
        smallCache.setObject("Value1", forKey: "Key1")
        smallCache.setObject("Value2", forKey: "Key2") // Cost exceeded
        XCTAssertNil(smallCache.object(forKey: "Key1"))
        XCTAssertEqual(smallCache.object(forKey: "Key2"), "Value2")
    }

    func testUnlimitedCacheStoresAllObjects() {
        let cache = CacheService<String, String>()
        for i in 1...1_000 {
            cache.setObject("Value\(i)", forKey: "Key\(i)")
        }
        XCTAssertEqual(cache.object(forKey: "Key1000"), "Value1000")
        XCTAssertEqual(cache.object(forKey: "Key1"), "Value1")
    }
}
