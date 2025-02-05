import Foundation

protocol CacheServiceType {
    associatedtype Key: Hashable
    associatedtype Value
    func object(forKey key: Key) -> Value?
    func setObject(_ object: Value, forKey key: Key)
    func clear()
}

final class CacheService<Key: Hashable, Value>: CacheServiceType {
    private let cache = NSCache<WrappedKey, Entry>()

    init(countLimit: Int? = nil, totalCostLimit: Int? = nil) {
        cache.countLimit = countLimit ?? 0
        cache.totalCostLimit = totalCostLimit ?? 0
    }

    func object(forKey key: Key) -> Value? {
        guard let entry = cache.object(forKey: WrappedKey(key)) else { 
            return nil
        }
        return entry.value
    }

    func setObject(_ object: Value, forKey key: Key) {
        let entry = Entry(value: object)
        cache.setObject(entry, forKey: WrappedKey(key))
    }

    func clear() {
        cache.removeAllObjects()
    }
}

// MARK: - Wrapper Classes
private extension CacheService {
    /// A wrapper to convert generic `Key` to `NSCopying` required by `NSCache`.
    final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) {
            self.key = key
        }

        override var hash: Int {
            return key.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? WrappedKey else {
                return false
            }
            return key == other.key
        }
    }

    /// A wrapper to store the `Value` in the cache.
    final class Entry {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}
