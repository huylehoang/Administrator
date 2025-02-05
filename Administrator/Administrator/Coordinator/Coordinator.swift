/// A protocol defining the Coordinator pattern for managing navigation flows.
///
/// ### Why Use a UIKit Coordinator with UIHostingController for SwiftUI?
///
/// The Coordinator pattern is implemented using UIKit to manage navigation flows
/// and wraps SwiftUI views in `UIHostingController` instead of using SwiftUI's navigation tools.
/// This approach is preferred because:
///
/// 1. **Separation of Concerns**:
///    - Navigation logic is centralized in the Coordinator, independent of the SwiftUI view.
///    - Views remain focused solely on UI and user interaction, improving reusability.
///
/// 2. **Better Handling of Complex Flows**:
///    - SwiftUI's state-driven navigation can be limiting or cumbersome for multi-screen flows,
///      conditional navigation, or deep-linking.
///    - UIKit Coordinators simplify managing these flows with direct control over navigation stack.
///
/// 3. **Modular and Testable**:
///    - Navigation logic in the Coordinator can be easily tested independently of UI rendering.
///    - This improves maintainability and scalability, especially in modular app architectures.
///
/// 4. **Incremental SwiftUI Adoption**:
///    - Existing UIKit-based apps can gradually adopt SwiftUI views without overhauling the
///      navigation system.
///    - SwiftUI views are seamlessly integrated into the navigation stack via
///     `UIHostingController`.
///
/// While SwiftUI-based Coordinators are emerging, this hybrid approach combines the robustness of
/// UIKit navigation with the declarative power of SwiftUI for building user interfaces.
///
/// For more information, check out the article:
///  [Coordinators in SwiftUI](https://vbat.dev/coordinators-swiftui)
///
/// ### Protocol Usage:
/// This protocol allows managing app navigation and orchestrating the presentation of views
/// through a central coordinator.
public protocol Coordinator {
    /// Starts the flow managed by the coordinator.
    func start()
}
