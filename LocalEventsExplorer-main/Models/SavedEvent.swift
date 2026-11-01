import Foundation
import SwiftData

@Model
final class SavedEvent {
    var eventID: String
    var name: String
    var category: String
    var city: String
    var latitude: Double
    var longitude: Double
    var venueName: String
    var eventDate: String
    var priceMin: Double
    var priceMax: Double
    var dateSaved: Date

    init(eventID: String, name: String, category: String, city: String,
         latitude: Double, longitude: Double, venueName: String,
         eventDate: String, priceMin: Double, priceMax: Double,
         dateSaved: Date = Date()) {
        self.eventID = eventID
        self.name = name
        self.category = category
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        self.venueName = venueName
        self.eventDate = eventDate
        self.priceMin = priceMin
        self.priceMax = priceMax
        self.dateSaved = dateSaved
    }
}
