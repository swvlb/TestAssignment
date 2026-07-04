import Foundation

// nil — поле валидно, иначе текст ошибки.
typealias ValidationError = String?

enum RegistrationValidators {

    static func validateName(_ value: String) -> ValidationError {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard trimmed.count >= 2 else {
            return "Имя должно содержать не менее 2 символов"
        }
        guard trimmed.allSatisfy({ $0.isLetter || $0 == "-" }) else {
            return "Имя может содержать только буквы"
        }
        return nil
    }

    static func validateLastName(_ value: String) -> ValidationError {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard trimmed.count >= 2 else {
            return "Фамилия должна содержать не менее 2 символов"
        }
        guard trimmed.allSatisfy({ $0.isLetter || $0 == "-" }) else {
            return "Фамилия может содержать только буквы"
        }
        return nil
    }

    static func validateBirthDate(_ date: Date?, calendar: Calendar = .current, now: Date = Date()) -> ValidationError {
        guard let date else {
            return "Укажите дату рождения"
        }
        guard date <= now else {
            return "Дата рождения не может быть в будущем"
        }
        let age = calendar.dateComponents([.year], from: date, to: now).year ?? 0
        guard age >= 14 else {
            return "Регистрация доступна с 14 лет"
        }
        guard age <= 120 else {
            return "Проверьте корректность даты рождения"
        }
        return nil
    }

    static func validatePassword(_ value: String) -> ValidationError {
        guard value.count >= 8 else {
            return "Пароль должен содержать не менее 8 символов"
        }
        guard value.contains(where: { $0.isNumber }) else {
            return "Пароль должен содержать хотя бы одну цифру"
        }
        guard value.contains(where: { $0.isUppercase }) else {
            return "Пароль должен содержать заглавную букву"
        }
        return nil
    }

    static func validatePasswordConfirmation(_ password: String, _ confirmation: String) -> ValidationError {
        guard !confirmation.isEmpty else {
            return "Подтвердите пароль"
        }
        guard password == confirmation else {
            return "Пароли не совпадают"
        }
        return nil
    }
}
