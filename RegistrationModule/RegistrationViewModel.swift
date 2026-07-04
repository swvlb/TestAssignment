import Foundation
import Combine

@MainActor
final class RegistrationViewModel: ObservableObject {

    enum Field {
        case firstName, lastName, birthDate, password, passwordConfirmation
    }

    // MARK: - Input

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date? = nil
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""

    // MARK: - Output

    @Published private(set) var firstNameError: ValidationError = nil
    @Published private(set) var lastNameError: ValidationError = nil
    @Published private(set) var birthDateError: ValidationError = nil
    @Published private(set) var passwordError: ValidationError = nil
    @Published private(set) var passwordConfirmationError: ValidationError = nil

    @Published private(set) var isFormValid: Bool = false
    @Published var didRegister: Bool = false

    private var touchedFields: Set<Field> = []
    private let sessionStorage: UserSessionStorage
    private var cancellables = Set<AnyCancellable>()

    init(sessionStorage: UserSessionStorage = UserDefaultsSessionStorage()) {
        self.sessionStorage = sessionStorage
        self.observeChanges()
    }

    // MARK: - Actions

    func markTouched(_ field: Field) {
        self.touchedFields.insert(field)
        self.revalidate()
    }

    func register() {
        self.touchedFields = [.firstName, .lastName, .birthDate, .password, .passwordConfirmation]
        self.revalidate()
        guard self.isFormValid else { return }

        self.sessionStorage.saveRegistration(firstName: self.firstName.trimmingCharacters(in: .whitespaces))
        self.didRegister = true
    }
}

// MARK: - Validation

private extension RegistrationViewModel {

    func observeChanges() {
        Publishers.CombineLatest4($firstName, $lastName, $birthDate, $password)
            .combineLatest($passwordConfirmation)
            .sink { [weak self] combined, passwordConfirmation in
                let (firstName, lastName, birthDate, password) = combined
                self?.revalidate(
                    firstName: firstName,
                    lastName: lastName,
                    birthDate: birthDate,
                    password: password,
                    passwordConfirmation: passwordConfirmation
                )
            }
            .store(in: &self.cancellables)
    }

    // Значения передаются из Combine-цепочки; при ручном вызове берём текущие self.*.
    func revalidate(
        firstName: String? = nil,
        lastName: String? = nil,
        birthDate: Date?? = nil,
        password: String? = nil,
        passwordConfirmation: String? = nil
    ) {
        let firstName = firstName ?? self.firstName
        let lastName = lastName ?? self.lastName
        let birthDate = birthDate ?? self.birthDate
        let password = password ?? self.password
        let passwordConfirmation = passwordConfirmation ?? self.passwordConfirmation

        let firstNameResult = RegistrationValidators.validateName(firstName)
        let lastNameResult = RegistrationValidators.validateLastName(lastName)
        let birthDateResult = RegistrationValidators.validateBirthDate(birthDate)
        let passwordResult = RegistrationValidators.validatePassword(password)
        let confirmationResult = RegistrationValidators.validatePasswordConfirmation(password, passwordConfirmation)

        self.firstNameError = self.touchedFields.contains(.firstName) ? firstNameResult : nil
        self.lastNameError = self.touchedFields.contains(.lastName) ? lastNameResult : nil
        self.birthDateError = self.touchedFields.contains(.birthDate) ? birthDateResult : nil
        self.passwordError = self.touchedFields.contains(.password) ? passwordResult : nil
        self.passwordConfirmationError = self.touchedFields.contains(.passwordConfirmation) ? confirmationResult : nil

        // Валидность кнопки зависит от данных, а не от того, тронуты ли поля.
        self.isFormValid = firstNameResult == nil
            && lastNameResult == nil
            && birthDateResult == nil
            && passwordResult == nil
            && confirmationResult == nil
    }
}
