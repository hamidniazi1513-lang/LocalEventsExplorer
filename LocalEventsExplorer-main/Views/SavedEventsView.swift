import SwiftUI
import SwiftData

struct SavedEventsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \SavedEvent.dateSaved, order: .reverse)
    private var savedEvents: [SavedEvent]
    @State private var searchText = ""

    private var filteredEvents: [SavedEvent] {
        guard !searchText.isEmpty else { return savedEvents }
        return savedEvents.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.city.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            if filteredEvents.isEmpty {
                ContentUnavailableView(
                    searchText.isEmpty ? "No Saved Events" : "No Results",
                    systemImage: "heart",
                    description: Text(searchText.isEmpty
                        ? "Events you save will appear here."
                        : "Try another search.")
                )
            } else {
                ForEach(filteredEvents, id: \.eventID) { event in
                    NavigationLink {
                        SavedEventDetailView(savedEvent: event)
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(event.name).font(.headline)
                            Text("\(event.category) • \(event.city)")
                                .font(.subheadline).foregroundStyle(.secondary)
                            Text("Venue: \(event.venueName)").font(.caption)
                            Text("Date: \(event.eventDate)").font(.caption)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .onDelete(perform: deleteEvents)
            }
        }
        .navigationTitle("Saved Events")
        .searchable(text: $searchText, prompt: "Search saved events")
    }

    private func deleteEvents(at offsets: IndexSet) {
        for index in offsets {
            context.delete(filteredEvents[index])
        }
    }
}
