import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(sort: \FavoriteDriver.addedAt) private var favoriteDrivers: [FavoriteDriver]
    @Query(sort: \FavoriteConstructor.addedAt) private var favoriteConstructors: [FavoriteConstructor]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                if favoriteDrivers.isEmpty && favoriteConstructors.isEmpty {
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "star",
                        description: Text("Add favorite drivers and teams from standings")
                    )
                } else {
                    if !favoriteDrivers.isEmpty {
                        Section("Favorite Drivers") {
                            ForEach(favoriteDrivers) { favorite in
                                HStack(spacing: GridPulseSpacing.sm) {
                                    TeamColorBadge(
                                        constructorId: favorite.constructorId,
                                        driverCode: favorite.driverCode,
                                        size: 32
                                    )
                                    Text(favorite.driverId.replacingOccurrences(of: "_", with: " "))
                                        .font(GridPulseTypography.body)
                                        .foregroundStyle(.gridOnSurface)
                                }
                            }
                            .onDelete(perform: deleteDriver)
                        }
                    }

                    if !favoriteConstructors.isEmpty {
                        Section("Favorite Teams") {
                            ForEach(favoriteConstructors) { favorite in
                                HStack(spacing: GridPulseSpacing.sm) {
                                    Circle()
                                        .fill(Color.teamColor(for: favorite.constructorId))
                                        .frame(width: 24, height: 24)

                                    Text(favorite.constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                                        .font(GridPulseTypography.body)
                                        .foregroundStyle(.gridOnSurface)
                                }
                            }
                            .onDelete(perform: deleteConstructor)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.gridBackground)
            .navigationTitle("Favorites")
        }
    }

    // MARK: - Delete
    private func deleteDriver(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favoriteDrivers[index])
        }
        try? modelContext.save()
    }

    private func deleteConstructor(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favoriteConstructors[index])
        }
        try? modelContext.save()
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: [FavoriteDriver.self, FavoriteConstructor.self])
}