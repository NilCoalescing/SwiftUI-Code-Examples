import SwiftUI

let animalGroups = [
    AnimalGroup(
        name: "Birds",
        animals: [
            Animal(name: "Kiwi"),
            Animal(name: "Takahē"),
            Animal(name: "Weka")
        ]
    ),
    AnimalGroup(
        name: "Reptiles",
        animals: [
            Animal(name: "Forest gecko"),
            Animal(name: "Barrier skink"),
            Animal(name: "Tuatara")
        ]
    ),
    AnimalGroup(
        name: "Bats",
        animals: [
            Animal(name: "Long-tailed bat"),
            Animal(name: "Short-tailed bat")
        ]
    )
]

struct ContentView: View {
    var body: some View {
        AnimalGroupsView(groups: animalGroups)
    }
}

struct AnimalGroupsView: View {
    var groups: [AnimalGroup]
    
    @State private var path: [AnimalGroup.ID] = ["Birds"]
    
    var body: some View {
        NavigationStack(path: $path) {
            List(groups) { group in
                NavigationLink(group.name, value: group.id)
            }
            .navigationDestination(
                for: AnimalGroup.ID.self
            ) { groupId in
                AnimalGroupView(groupId: groupId)
            }
            .navigationTitle("NZ Native Animals")
        }
    }
}

struct AnimalGroupView: View {
    var groupId: AnimalGroup.ID
    @State var group: AnimalGroup?
    
    var body: some View {
        Group {
            if let group = group {
                List(group.animals) { animal in
                    Text(animal.name)
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(groupId)
        .task(id: groupId) {
            // we could load the data from some database
            group = animalGroups.first { $0.id == groupId }
        }
    }
}

struct AnimalGroup: Identifiable {
    let name: String
    let animals: [Animal]
    
    var id: String { name }
}

struct Animal: Identifiable {
    let name: String
    
    var id: String { name }
}
