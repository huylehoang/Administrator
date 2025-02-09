import Foundation

protocol ProcessInfoType {
    var arguments: [String] { get }
    var environment: [String: String] { get }
}

extension ProcessInfo: ProcessInfoType {}
