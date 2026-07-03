import Foundation

final class RemoteProductsRepository: ProductsRepository {

    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        baseURL: URL = URL(string: "https://fakestoreapi.com")!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = JSONDecoder()
    }

    func fetchProducts() async throws -> [Product] {
        let url = self.baseURL.appendingPathComponent("products")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await self.session.data(from: url)
        } catch {
            throw NetworkError.underlying(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        do {
            let dtos = try self.decoder.decode([ProductDTO].self, from: data)
            return dtos.map { $0.toDomain() }
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
