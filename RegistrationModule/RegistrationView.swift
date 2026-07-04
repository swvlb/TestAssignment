import SwiftUI

struct RegistrationView: View {

    @StateObject private var viewModel = RegistrationViewModel()

    let onRegistered: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                self.form
                Divider()
                self.footer
            }
            .navigationTitle("Регистрация")
            .onChange(of: self.viewModel.didRegister) { didRegister in
                if didRegister {
                    self.onRegistered()
                }
            }
        }
    }
}

// MARK: - Subviews

private extension RegistrationView {

    var form: some View {
        ScrollView {
            VStack(spacing: 20) {
                TitledTextField(
                    title: "Имя",
                    text: self.$viewModel.firstName,
                    error: self.viewModel.firstNameError,
                    onCommit: { self.viewModel.markTouched(.firstName) }
                )

                TitledTextField(
                    title: "Фамилия",
                    text: self.$viewModel.lastName,
                    error: self.viewModel.lastNameError,
                    onCommit: { self.viewModel.markTouched(.lastName) }
                )

                self.birthDateField

                TitledSecureField(
                    title: "Пароль",
                    text: self.$viewModel.password,
                    error: self.viewModel.passwordError,
                    onCommit: { self.viewModel.markTouched(.password) }
                )

                TitledSecureField(
                    title: "Подтверждение пароля",
                    text: self.$viewModel.passwordConfirmation,
                    error: self.viewModel.passwordConfirmationError,
                    onCommit: { self.viewModel.markTouched(.passwordConfirmation) }
                )
            }
            .padding()
        }
    }

    var footer: some View {
        self.registerButton
            .padding()
            .background(Color(.systemBackground))
    }

    var registerButton: some View {
        Button(action: self.viewModel.register) {
            Text("Регистрация")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(self.viewModel.isFormValid ? AnyView(AppTheme.gradient) : AnyView(Color.gray.opacity(0.3)))
                .foregroundColor(.white)
                .cornerRadius(14)
                .shadow(
                    color: self.viewModel.isFormValid ? AppTheme.primary.opacity(0.35) : .clear,
                    radius: 8, x: 0, y: 4
                )
        }
        .disabled(!self.viewModel.isFormValid)
    }
}

// MARK: - Birth date

private extension RegistrationView {

    // Дата по умолчанию, которую показывает календарь, пока пользователь не выбрал свою.
    var defaultBirthDate: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    }

    // birthDate в модели остаётся nil, пока пользователь не тронул календарь,
    // поэтому валидация "Укажите дату рождения" работает как прежде.
    var birthDateBinding: Binding<Date> {
        Binding(
            get: { self.viewModel.birthDate ?? self.defaultBirthDate },
            set: { newValue in
                self.viewModel.birthDate = newValue
                self.viewModel.markTouched(.birthDate)
            }
        )
    }

    var birthDateField: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Дата рождения")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                UIKitDatePicker(date: self.birthDateBinding)
                    .frame(width: 128, height: 36)
            }
            .appFieldStyle(hasError: self.viewModel.birthDateError != nil)

            if let error = self.viewModel.birthDateError {
                Text(error).font(.caption).foregroundColor(AppTheme.primary)
            }
        }
    }
}

// MARK: - Reusable fields

struct TitledTextField: View {
    let title: String
    @Binding var text: String
    let error: ValidationError
    let onCommit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(self.title).font(.subheadline).foregroundColor(.secondary)

            TextField(self.title, text: self.$text, onEditingChanged: { isEditing in
                if !isEditing { self.onCommit() }
            })
            .autocapitalization(.words)
            .appFieldStyle(hasError: self.error != nil)

            if let error = self.error {
                Text(error).font(.caption).foregroundColor(AppTheme.primary)
            }
        }
    }
}

struct TitledSecureField: View {
    let title: String
    @Binding var text: String
    let error: ValidationError
    let onCommit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(self.title).font(.subheadline).foregroundColor(.secondary)

            SecureField(self.title, text: self.$text)
                .appFieldStyle(hasError: self.error != nil)
                .onSubmit(self.onCommit)
                // SecureField не отдаёт onEditingChanged — трогаем поле по изменению текста.
                .onChange(of: self.text) { _ in self.onCommit() }

            if let error = self.error {
                Text(error).font(.caption).foregroundColor(AppTheme.primary)
            }
        }
    }
}

// MARK: - Field style

// Единый вид полей: мягкая подложка, скругление, красная рамка при ошибке.
private struct AppFieldStyle: ViewModifier {
    let hasError: Bool

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(AppTheme.fieldBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        self.hasError ? AppTheme.primary : Color.black.opacity(0.06),
                        lineWidth: self.hasError ? 1.5 : 1
                    )
            )
    }
}

private extension View {
    func appFieldStyle(hasError: Bool) -> some View {
        modifier(AppFieldStyle(hasError: hasError))
    }
}

#if DEBUG
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(onRegistered: {})
    }
}
#endif
