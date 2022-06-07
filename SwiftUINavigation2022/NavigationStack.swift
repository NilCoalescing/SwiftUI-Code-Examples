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
    
    var body: some View {
        NavigationStack {
            List(groups) { group in
                NavigationLink(group.name) {
                    AnimalGroupView(group: group)
                }
            }
            .navigationTitle("NZ Native Animals")
        }
    }
}

struct AnimalGroupView: View {
    var group: AnimalGroup
    
    var body: some View {
        List(group.animals) { animal in
            Text(animal.name)
        }
        .navigationTitle(group.name)
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
