import Foundation

// Отражение JSON от fakestoreapi.com/products, маппится в Product.
struct ProductDTO: Decodable {
    let id: Int
    let title: String
    let price: Double
    let category: String?
    let image: String?

    func toDomain() -> Product {
        Product(
            id: self.id,
            title: self.title,
            price: self.price,
            category: self.category,
            imageURL: self.image.flatMap(URL.init(string:))
        )
    }
}
