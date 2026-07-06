import Foundation
@testable import TestAssignment

final class MockUserSessionStorage: UserSessionStorage {
    private(set) var isRegistered: Bool = false
    private(set) var firstName: String?

    func saveRegistration(firstName: String) {
        self.isRegistered = true
        self.firstName = firstName
    }

    func clear() {
        isRegistered = false
        firstName = nil
    }
}

final class MockProductsRepository: ProductsRepository {
    var stubbedProducts: [Product] = []
    var stubbedError: Error?

    func fetchProducts() async throws -> [Product] {
        if let stubbedError {
            throw stubbedError
        }
        return stubbedProducts
    }
}
