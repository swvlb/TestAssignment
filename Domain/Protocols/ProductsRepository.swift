import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decoding(Error)
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный адрес запроса"
        case .invalidResponse:
            return "Сервер вернул некорректный ответ"
        case .statusCode(let code):
            return "Ошибка сервера (код \(code))"
        case .decoding:
            return "Не удалось обработать ответ сервера"
        case .underlying:
            return "Не удалось загрузить данные. Проверьте подключение к интернету и попробуйте снова."
        }
    }
}

protocol ProductsRepository {
    func fetchProducts() async throws -> [Product]
}
