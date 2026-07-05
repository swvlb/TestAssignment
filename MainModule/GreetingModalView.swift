import SwiftUI

struct GreetingModalView: View {
    let text: String
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            self.icon
            Text(self.text)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            Spacer()
            self.closeButton
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Subviews

private extension GreetingModalView {

    var icon: some View {
        ZStack {
            Circle()
                .fill(AppTheme.primary.opacity(0.12))
                .frame(width: 110, height: 110)
            Image(systemName: "hand.wave.fill")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.primary)
        }
    }

    var closeButton: some View {
        Button(action: self.onClose) {
            Text("Закрыть")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.gradient)
                .foregroundColor(.white)
                .cornerRadius(14)
        }
    }
}
