@testable import Administrator
import XCTest

final class DownloadImageErrorTests: XCTestCase {
    func testApiErrorLocalizedDescription() {
        XCTAssertEqual(
            DownloadImageError.downloadFailed.localizedDescription,
            "Image download failed."
        )
    }
}
