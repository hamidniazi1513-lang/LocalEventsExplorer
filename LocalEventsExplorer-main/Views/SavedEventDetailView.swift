import SwiftUI
import SwiftData
import Charts
import FoundationModels

struct SavedEventDetailView: View {
    let savedEvent: SavedEvent

    @State private var selectedPriceType: String?
    @State private var tips: EventTip?
    @State private var isGeneratingTips = false
    @State private var errorMessage: String?

    private var priceData: [(label: String, price: Double)] {
        [("Minimum", savedEvent.priceMin), ("Maximum", savedEvent.priceMax)]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(savedEvent.name).font(.largeTitle.bold())
                Text("\(savedEvent.category) • \(savedEvent.city)")
                    .foregroundStyle(.secondary)
                Text("Venue: \(savedEvent.venueName)")
                Text("Date: \(savedEvent.eventDate)")
                Text("Ticket Price").font(.headline)

                Chart(priceData, id: \.label) { item in
                    AreaMark(
                        x: .value("Price Type", item.label),
                        y: .value("Price", item.price)
                    )
                    LineMark(
                        x: .value("Price Type", item.label),
                        y: .value("Price", item.price)
                    )
                }
                .frame(height: 200)
                .chartXSelection(value: $selectedPriceType)

                Button {
                    Task { await generateTips() }
                } label: {
                    if isGeneratingTips {
                        ProgressView("Generating tips...")
                    } else {
                        Label("Generate Event Tips", systemImage: "sparkles")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isGeneratingTips)

                if let tips {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Outfit: \(tips.outfitSuggestion)")
                        Text("Bring: \(tips.itemToBring)")
                        Text("Arrival: \(tips.arrivalTip)")
                    }
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.red)
                    Text("Fallback: Check the event venue, weather, ticket and arrival time before leaving.")
                        .font(.footnote)
                }
            }
            .padding()
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    @MainActor
    private func generateTips() async {
        isGeneratingTips = true
        errorMessage = nil
        defer { isGeneratingTips = false }

        do {
            let model = SystemLanguageModel.default
            guard model.isAvailable else {
                errorMessage = "Apple Intelligence is unavailable. Use the fallback advice below."
                return
            }
            let session = LanguageModelSession()
            let prompt = """
            Give practical tips for attending this event.
            Event: \(savedEvent.name)
            Category: \(savedEvent.category)
            City: \(savedEvent.city)
            Venue: \(savedEvent.venueName)
            """
            let response = try await session.respond(
                to: prompt,
                generating: EventTip.self
            )
            tips = response.content
        } catch {
            errorMessage = "Could not generate tips: \(error.localizedDescription)"
        }
    }
}
