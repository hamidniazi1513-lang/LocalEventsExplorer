import Foundation

enum EventsServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case missingHostedURL

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The events URL is invalid."
        case .invalidResponse: return "The server returned an invalid response."
        case .badStatusCode(let code): return "The server returned HTTP status \(code)."
        case .missingHostedURL:
            return "Add the exact hosted events JSON URL supplied in the course materials."
        }
    }
}

struct EventsService {
    // The assignment text does not include the complete hosted JSON URL.
    // Replace this value with the exact URL from the course lesson/resources.
    private let hostedJSONURL = "PASTE_THE_EXACT_HOSTED_EVENTS_JSON_URL_HERE"

    func fetchEvents() async throws -> [Event] {
        guard hostedJSONURL.hasPrefix("https://"),
              let url = URL(string: hostedJSONURL) else {
            throw EventsServiceError.missingHostedURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw EventsServiceError.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw EventsServiceError.badStatusCode(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(EventsResponse.self, from: data)
        return result.events
    }
}
