import SwiftUI
import MapKit

struct EventsMapView: View {
    let events: [Event]

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 31.0, longitude: -99.0),
            span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8)
        )
    )
    @State private var selectedCategory = "All"
    @State private var selectedMapStyle = "Standard"

    private var categories: [String] {
        ["All"] + Array(Set(events.map(\.category))).sorted()
    }

    private var filteredEvents: [Event] {
        selectedCategory == "All"
            ? events
            : events.filter { $0.category == selectedCategory }
    }

    private var currentMapStyle: MapStyle {
        switch selectedMapStyle {
        case "Imagery": return .imagery
        case "Hybrid": return .hybrid
        default: return .standard
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Picker("Map Style", selection: $selectedMapStyle) {
                Text("Standard").tag("Standard")
                Text("Imagery").tag("Imagery")
                Text("Hybrid").tag("Hybrid")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Map(position: $cameraPosition) {
                ForEach(filteredEvents) { event in
                    Annotation(
                        event.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: event.latitude,
                            longitude: event.longitude
                        )
                    ) {
                        VStack(spacing: 2) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title).foregroundStyle(.red)
                            Text(event.name)
                                .font(.caption2)
                                .padding(4)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                }
                UserAnnotation()
            }
            .mapStyle(currentMapStyle)
            .mapControls {
                MapCompass()
                MapScaleView()
            }

            Button {
                withAnimation {
                    cameraPosition = .userLocation(fallback: .automatic)
                }
            } label: {
                Label("My Location", systemImage: "location.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
    }
}
