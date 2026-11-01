
import Foundation
import Observation

@MainActor
@Observable
final class EventsViewModel {

    var citySearchText: String = ""
    var events: [Event] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private let service = EventsService()

    var filteredEvents: [Event] {
        guard !citySearchText.isEmpty else {
            return events
        }

        return events.filter {
            $0.city.localizedCaseInsensitiveContains(citySearchText)
        }
    }

    func loadEvents() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            events = try await service.fetchEvents()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
