import SwiftUI

struct EventCard: View {
    let event: Event
    let isSaved: Bool
    let onSaveTapped: () -> Void

    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 22

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(event.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button(action: onSaveTapped) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.system(size: iconSize))
                        .foregroundStyle(isSaved ? .red : .primary)
                }
                .buttonStyle(.plain)
            }

            Text(event.name)
                .font(.headline)

            Text("\(event.city) • \(event.venueName)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Text(event.eventDate)
                    .font(.caption)

                Spacer()

                Text("\(event.priceMin, specifier: "%.0f") – \(event.priceMax, specifier: "%.0f") KZT")
                    .font(.subheadline.bold())
                    .contentTransition(.numericText())
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}