import XCTest
@testable import TestAssignment

final class RegistrationValidatorsTests: XCTestCase {

    // MARK: - Name

    func test_validateName_tooShort_returnsError() {
        XCTAssertNotNil(RegistrationValidators.validateName("A"))
    }

    func test_validateName_withDigits_returnsError() {
        XCTAssertNotNil(RegistrationValidators.validateName("An1"))
    }

    func test_validateName_valid_returnsNil() {
        XCTAssertNil(RegistrationValidators.validateName("Anna"))
    }

    // MARK: - Password

    func test_validatePassword_tooShort_returnsError() {
        XCTAssertNotNil(RegistrationValidators.validatePassword("Ab1"))
    }

    func test_validatePassword_noDigit_returnsError() {
        XCTAssertNotNil(RegistrationValidators.validatePassword("Password"))
    }

    func test_validatePassword_noUppercase_returnsError() {
        XCTAssertNotNil(RegistrationValidators.validatePassword("password1"))
    }

    func test_validatePassword_valid_returnsNil() {
        XCTAssertNil(RegistrationValidators.validatePassword("Password1"))
    }

    // MARK: - Password confirmation

    func test_validatePasswordConfirmation_mismatch_returnsError() {
        XCTAssertNotNil(RegistrationValidators.validatePasswordConfirmation("Password1", "Password2"))
    }

    func test_validatePasswordConfirmation_match_returnsNil() {
        XCTAssertNil(RegistrationValidators.validatePasswordConfirmation("Password1", "Password1"))
    }

    // MARK: - Birth date

    func test_validateBirthDate_nil_returnsError() {
        XCTAssertNotNil(RegistrationValidators.validateBirthDate(nil))
    }

    func test_validateBirthDate_future_returnsError() {
        let future = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        XCTAssertNotNil(RegistrationValidators.validateBirthDate(future))
    }

    func test_validateBirthDate_tooYoung_returnsError() {
        let recent = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        XCTAssertNotNil(RegistrationValidators.validateBirthDate(recent))
    }

    func test_validateBirthDate_valid_returnsNil() {
        let adult = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        XCTAssertNil(RegistrationValidators.validateBirthDate(adult))
    }
}
