import SwiftUI

@main
struct TrialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct Plant: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let note: String
}

struct ContentView: View {
    @State private var plants: [Plant] = [
        Plant(name: "Fern", note: "Likes shade"),
        Plant(name: "Basil", note: "Water daily"),
        Plant(name: "Cactus", note: "Leave it alone"),
    ]
    @State private var newName = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Add a plant") {
                    HStack {
                        TextField("Plant name", text: $newName)
                            .accessibilityIdentifier("newPlantField")
                        Button("Add") {
                            let name = newName.trimmingCharacters(in: .whitespaces)
                            guard !name.isEmpty else { return }
                            plants.append(Plant(name: name, note: "New"))
                            newName = ""
                        }
                        .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                        .accessibilityIdentifier("addPlantButton")
                    }
                }
                Section("Plants (\(plants.count))") {
                    ForEach(plants) { plant in
                        NavigationLink(value: plant) {
                            Text(plant.name)
                        }
                    }
                }
            }
            .navigationTitle("Trial Plants")
            .navigationDestination(for: Plant.self) { plant in
                PlantDetail(plant: plant)
            }
        }
    }
}

struct PlantDetail: View {
    let plant: Plant
    @State private var watered = false

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: watered ? "drop.fill" : "leaf")
                .font(.system(size: 64))
                .foregroundStyle(watered ? .blue : .green)
            Text(plant.name).font(.largeTitle.bold())
            Text(plant.note).foregroundStyle(.secondary)
            Button(watered ? "Watered" : "Water it") { watered = true }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("waterButton")
        }
        .padding()
        .navigationTitle(plant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
