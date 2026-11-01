
import SwiftUI

struct EventCardView: View {

    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(event.name)
                .font(.headline)

            Text(event.category)
                .font(.subheadline)
                .foregroundColor(.blue)

            Label(event.city, systemImage: "location")

            Label(event.eventDate, systemImage: "calendar")

            Text("\(Int(event.priceMin)) - \(Int(event.priceMax)) KZT")
                .font(.subheadline)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
