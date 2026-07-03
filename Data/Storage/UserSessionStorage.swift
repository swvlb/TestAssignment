import Foundation

protocol UserSessionStorage {
    var isRegistered: Bool { get }
    var firstName: String? { get }

    func saveRegistration(firstName: String)
    func clear()
}

final class UserDefaultsSessionStorage: UserSessionStorage {

    private enum Keys {
        static let isRegistered = "com.regapp.isRegistered"
        static let firstName = "com.regapp.firstName"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isRegistered: Bool {
        self.defaults.bool(forKey: Keys.isRegistered)
    }

    var firstName: String? {
        self.defaults.string(forKey: Keys.firstName)
    }

    func saveRegistration(firstName: String) {
        self.defaults.set(true, forKey: Keys.isRegistered)
        self.defaults.set(firstName, forKey: Keys.firstName)
    }

    func clear() {
        self.defaults.removeObject(forKey: Keys.isRegistered)
        self.defaults.removeObject(forKey: Keys.firstName)
    }
}
