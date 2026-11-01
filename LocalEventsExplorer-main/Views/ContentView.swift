import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var savedEvents: [SavedEvent]
    @State private var viewModel = EventsViewModel()
    @State private var animateCards = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        TabView {
            NavigationStack { eventsScreen }
                .tabItem { Label("Events", systemImage: "calendar") }
            NavigationStack {
                EventsMapView(events: viewModel.events).navigationTitle("Event Map")
            }
            .tabItem { Label("Map", systemImage: "map") }
            NavigationStack { SavedEventsView() }
                .tabItem { Label("Saved", systemImage: "heart") }
        }
        .task {
            await viewModel.loadEvents()
            withAnimation { animateCards = true }
        }
    }

    private var eventsScreen: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading events...").padding()
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text(error).foregroundStyle(.red)
                    Button("Retry") { Task { await viewModel.loadEvents() } }
                        .buttonStyle(.borderedProminent)
                }.padding()
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Array(viewModel.filteredEvents.enumerated()), id: \.element.id) { item in
                        let event = item.element
                        let existing = savedEvents.first { $0.eventID == event.id }
                        EventCard(event: event, isSaved: existing != nil) {
                            toggleSaved(event)
                        }
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 60)
                        .animation(.easeInOut(duration: 0.4).delay(Double(item.offset) * 0.05),
                                   value: animateCards)
                    }
                }.padding()
            }
        }
        .navigationTitle("Explore Events")
        .searchable(text: $viewModel.citySearchText, prompt: "Search by city")
    }

    private func toggleSaved(_ event: Event) {
        if let saved = savedEvents.first(where: { $0.eventID == event.id }) {
            context.delete(saved)
        } else {
            context.insert(SavedEvent(
                eventID: event.id, name: event.name, category: event.category,
                city: event.city, latitude: event.latitude, longitude: event.longitude,
                venueName: event.venueName, eventDate: event.eventDate,
                priceMin: event.priceMin, priceMax: event.priceMax
            ))
        }
    }
}
