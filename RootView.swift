import SwiftUI

/// Единая палитра приложения в красном фирменном стиле.
/// Держим цвета в одном месте, чтобы весь UI выглядел согласованно.
enum AppTheme {
    static let primary = Color(red: 0.80, green: 0.12, blue: 0.16)
    static let primaryDark = Color(red: 0.58, green: 0.07, blue: 0.10)
    static let fieldBackground = Color(.secondarySystemBackground)

    /// Диагональный красный градиент для акцентных элементов (кнопки, шапки).
    static var gradient: LinearGradient {
        LinearGradient(
            colors: [primary, primaryDark],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct RootView: View {

    @State private var isRegistered: Bool
    private let sessionStorage: UserSessionStorage

    init(sessionStorage: UserSessionStorage = UserDefaultsSessionStorage()) {
        self.sessionStorage = sessionStorage
        _isRegistered = State(initialValue: sessionStorage.isRegistered)
    }

    var body: some View {
        Group {
            if self.isRegistered {
                MainView {
                    self.isRegistered = false
                }
            } else {
                RegistrationView {
                    self.isRegistered = true
                }
            }
        }
        // Красный акцент для всех стандартных контролов ниже по дереву.
        .tint(AppTheme.primary)
    }
}
