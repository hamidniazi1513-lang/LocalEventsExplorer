import Foundation

struct Event: Codable, Identifiable {
    let id: String
    let name: String
    let category: String
    let city: String
    let latitude: Double
    let longitude: Double
    let venueName: String
    let eventDate: String
    let priceMin: Double
    let priceMax: Double

    enum CodingKeys: String, CodingKey {
        case id, name, category, city, latitude, longitude
        case venueName = "venue_name"
        case eventDate = "event_date"
        case priceMin = "price_min"
        case priceMax = "price_max"
    }
}
