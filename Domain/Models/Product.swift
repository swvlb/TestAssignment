import Foundation

struct Product: Identifiable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let category: String?
    let imageURL: URL?

    var formattedPrice: String {
        String(format: "$%.2f", self.price)
    }
}
