import SwiftUI
import MapKit

struct CircuitDetailView: View {
    let circuit: Circuit

    var body: some View {
        ScrollView {
            VStack(spacing: GridPulseSpacing.md) {
                circuitHeader
                circuitMap
                circuitInfo
            }
            .padding()
        }
        .background(Color.gridBackground)
        .navigationTitle(circuit.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header
    private var circuitHeader: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Text(circuit.name)
                    .font(GridPulseTypography.heroTitle)
                    .foregroundStyle(.gridOnSurface)

                HStack(spacing: GridPulseSpacing.sm) {
                    Label(circuit.locality, systemImage: "mappin.and.ellipse")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)

                    Label(circuit.country, systemImage: "globe")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                }
            }
        }
    }

    // MARK: - Map
    private var circuitMap: some View {
        GlassCard(cornerRadius: GridPulseSpacing.sm, padding: 0) {
            Map(initialPosition: .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: circuit.latitude, longitude: circuit.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )) {
                Marker(circuit.name, coordinate: CLLocationCoordinate2D(latitude: circuit.latitude, longitude: circuit.longitude))
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: GridPulseSpacing.sm))
        }
    }

    // MARK: - Info
    private var circuitInfo: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("CIRCUIT INFO", systemImage: "info.circle")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Location")
                            .font(GridPulseTypography.caption)
                            .foregroundStyle(.gridOnSurfaceSecondary)
                        Text("\(circuit.locality), \(circuit.country)")
                            .font(GridPulseTypography.body)
                            .foregroundStyle(.gridOnSurface)
                    }
                    Spacer()
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("Coordinates")
                            .font(GridPulseTypography.caption)
                            .foregroundStyle(.gridOnSurfaceSecondary)
                        Text("\(circuit.latitude, specifier: "%.4f"), \(circuit.longitude, specifier: "%.4f")")
                            .font(GridPulseTypography.mono)
                            .foregroundStyle(.gridOnSurface)
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        CircuitDetailView(circuit: Circuit(
            id: "monaco",
            name: "Circuit de Monaco",
            locality: "Monte Carlo",
            country: "Monaco",
            latitude: 43.7347,
            longitude: 7.4206
        ))
    }
    .modelContainer(for: [Circuit.self, CacheEntry.self])
}