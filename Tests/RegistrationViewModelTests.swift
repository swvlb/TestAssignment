import XCTest
@testable import TestAssignment

@MainActor
final class RegistrationViewModelTests: XCTestCase {

    func test_register_withInvalidForm_doesNotSaveSession() {
        let storage = MockUserSessionStorage()
        let viewModel = RegistrationViewModel(sessionStorage: storage)

        viewModel.register()

        XCTAssertFalse(viewModel.didRegister)
        XCTAssertFalse(storage.isRegistered)
        // После попытки регистрации с пустой формой ошибки должны показаться
        XCTAssertNotNil(viewModel.firstNameError)
    }

    func test_register_withValidForm_savesSessionAndSetsFlag() {
        let storage = MockUserSessionStorage()
        let viewModel = RegistrationViewModel(sessionStorage: storage)

        viewModel.firstName = "Anna"
        viewModel.lastName = "Ivanova"
        viewModel.birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date())
        viewModel.password = "Password1"
        viewModel.passwordConfirmation = "Password1"

        viewModel.register()

        XCTAssertTrue(viewModel.didRegister)
        XCTAssertTrue(storage.isRegistered)
        XCTAssertEqual(storage.firstName, "Anna")
    }

    func test_isFormValid_reflectsFieldValidity() {
        let viewModel = RegistrationViewModel(sessionStorage: MockUserSessionStorage())
        XCTAssertFalse(viewModel.isFormValid)

        viewModel.firstName = "Anna"
        viewModel.lastName = "Ivanova"
        viewModel.birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date())
        viewModel.password = "Password1"
        viewModel.passwordConfirmation = "Password1"

        XCTAssertTrue(viewModel.isFormValid)
    }
}
