import XCTest
@testable import TestAssignment

@MainActor
final class MainViewModelTests: XCTestCase {

    func test_loadProducts_success_updatesStateToLoaded() async {
        let repository = MockProductsRepository()
        repository.stubbedProducts = [
            Product(id: 1, title: "Test", price: 9.99, category: "test", imageURL: nil)
        ]
        let storage = MockUserSessionStorage()
        storage.saveRegistration(firstName: "Anna")

        let viewModel = MainViewModel(repository: repository, sessionStorage: storage)
        await viewModel.loadProducts()

        XCTAssertEqual(viewModel.loadState, .loaded)
        XCTAssertEqual(viewModel.products.count, 1)
        XCTAssertEqual(viewModel.products.first?.title, "Test")
    }

    func test_loadProducts_failure_updatesStateToFailed() async {
        let repository = MockProductsRepository()
        repository.stubbedError = NetworkError.statusCode(500)

        let viewModel = MainViewModel(repository: repository, sessionStorage: MockUserSessionStorage())
        await viewModel.loadProducts()

        guard case .failed = viewModel.loadState else {
            return XCTFail("Expected failed state")
        }
    }

    func test_greetingText_usesStoredFirstName() {
        let storage = MockUserSessionStorage()
        storage.saveRegistration(firstName: "Anna")

        let viewModel = MainViewModel(repository: MockProductsRepository(), sessionStorage: storage)

        XCTAssertEqual(viewModel.greetingText, "Привет, Anna!")
    }

    func test_logout_clearsSessionStorage() {
        let storage = MockUserSessionStorage()
        storage.saveRegistration(firstName: "Anna")
        let viewModel = MainViewModel(repository: MockProductsRepository(), sessionStorage: storage)

        viewModel.logout()

        XCTAssertFalse(storage.isRegistered)
        XCTAssertNil(storage.firstName)
    }
}
