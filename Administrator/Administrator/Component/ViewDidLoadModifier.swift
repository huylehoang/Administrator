import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var hasLoaded = false
    let onLoad: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasLoaded {
                    hasLoaded = true
                    onLoad()
                }
            }
    }
}

extension View {
    func onViewDidLoad(perform action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(onLoad: action))
    }
}
