import UIKit

final class MockWindow: UIWindow {
    var didCallMakeKeyAndVisible = false

    override func makeKeyAndVisible() {
        didCallMakeKeyAndVisible = true
    }
}
