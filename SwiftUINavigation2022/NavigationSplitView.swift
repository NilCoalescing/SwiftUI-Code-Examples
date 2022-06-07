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
        
    @State private var selection: Set<AnimalGroup.ID> = []
    
    var body: some View {
        NavigationSplitView {
            List(groups, selection: $selection) { group in
                Text(group.name)
            }
        } detail: {
            AnimalGroupsDetail(groupIds: selection)
        }
    }
}

struct AnimalGroupsDetail: View {
    var groupIds: Set<AnimalGroup.ID>
    
    var body: some View {
        List(Array(groupIds), id: \.self) { id in
            Section(id) {
                AnimalGroupSection(groupId: id)
            }
        }
    }
}

struct AnimalGroupSection: View {
    var groupId: AnimalGroup.ID
    
    var animals: [Animal] {
        animalGroups
            .first { $0.id == groupId }?
            .animals ?? []
    }
    
    var body: some View {
        ForEach(animals) { animal in
            Text(animal.name)
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
