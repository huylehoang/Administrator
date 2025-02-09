@testable import Administrator

final class MockProcessInfo: ProcessInfoType {
    var arguments = [String]()
    var environment = [String: String]()
}
