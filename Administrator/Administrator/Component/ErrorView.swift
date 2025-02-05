import SwiftUI

struct ErrorView: View {
    @Binding var errorMessage: String?

    var body: some View {
        if let errorMessage = errorMessage {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                VStack {
                    Text("Error")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding([.top], 8)
                        .padding([.leading, .trailing], 16)
                    Text(errorMessage)
                        .accessibilityIdentifier("error_message")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding(.vertical, 8)
                        .padding([.leading, .trailing], 16)
                    Button("Dismiss") {
                        self.errorMessage = nil
                    }
                    .padding([.leading, .trailing], 16)
                    .frame(height: 44)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding([.bottom], 16)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            }
            .animation(.easeInOut, value: errorMessage)
        }
    }
}
