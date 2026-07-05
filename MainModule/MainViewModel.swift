import Foundation

@MainActor
final class MainViewModel: ObservableObject {

    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var products: [Product] = []
    @Published private(set) var loadState: LoadState = .idle
    @Published var isGreetingPresented: Bool = false

    let userName: String

    private let repository: ProductsRepository
    private let sessionStorage: UserSessionStorage

    init(
        repository: ProductsRepository = RemoteProductsRepository(),
        sessionStorage: UserSessionStorage = UserDefaultsSessionStorage()
    ) {
        self.repository = repository
        self.sessionStorage = sessionStorage
        self.userName = sessionStorage.firstName ?? "Гость"
    }

    var greetingText: String {
        "Привет, \(self.userName)!"
    }

    func loadProducts() async {
        guard self.loadState != .loading else { return }
        self.loadState = .loading
        do {
            self.products = try await self.repository.fetchProducts()
            self.loadState = .loaded
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "Не удалось загрузить данные"
            self.loadState = .failed(message)
        }
    }

    func showGreeting() {
        self.isGreetingPresented = true
    }

    func logout() {
        self.sessionStorage.clear()
    }
}
