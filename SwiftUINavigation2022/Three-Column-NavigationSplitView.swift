import SwiftUI

let animalGroups = [
    AnimalGroup(
        name: "Birds",
        animals: [
            Animal(
                name: "Kiwi",
                description: """
                Kiwi are flightless birds endemic to New Zealand.
                They are the smallest living ratites, which also include ostriches, emus, rheas and cassowaries.
                """
            ),
            Animal(
                name: "Takahē",
                description: """
                Takahē is a flightless swamphen indigenous to New Zealand.
                It's the largest living member of the rail family.
                """
            ),
            Animal(
                name: "Weka",
                description: """
                Weka is a flightless bird species of the rail family, endemic to New Zealand.
                It's a sturdy brown bird, about the size of a chicken.
                """
            )
        ]
    ),
    AnimalGroup(
        name: "Reptiles",
        animals: [
            Animal(
                name: "Forest gecko",
                description: """
                Forest gecko is endemic to New Zealand and found in all areas except the Far North, Marlborough, and Canterbury.
                They are a protected species under the Wildlife Act 1953.
                """
            ),
            Animal(
                name: "Barrier skink",
                description: """
                Barrier skink (Oligosoma judgei) is a species of medium-sized skink, endemic to New Zealand.
                It lives in the alpine habitat of the Darran and Takitimu Mountains of Fiordland.
                """
            ),
            Animal(
                name: "Tuatara",
                description: """
                Tuatara are reptiles endemic to New Zealand.
                Tuatara is the only surviving member of the order Rhynchocephalia, originated during the Triassic.
                """
            )
        ]
    ),
    AnimalGroup(
        name: "Bats",
        animals: [
            Animal(
                name: "Long-tailed bat",
                description: """
                New Zealand long-tailed bat is one of the two surviving bat species endemic to New Zealand.
                The species first gained legal protection under the New Zealand Wildlife Act 1953.
                """
            ),
            Animal(
                name: "Short-tailed bat",
                description: """
                New Zealand lesser short-tailed bat is the only member of Mystacina that survives today.
                It's a small-sized omnivorous species endemic to the islands of New Zealand.
                """
            )
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
        
    @State private var groupIds: Set<AnimalGroup.ID> = []
    @State private var animalIds: Set<Animal.ID> = []
    
    var body: some View {
        NavigationSplitView {
            List(groups, selection: $groupIds) { group in
                Text(group.name)
            }
        } content: {
            AnimalGroupsDetail(groupIds: groupIds, animalIds: $animalIds)
        } detail: {
            AnimalsDetail(animalIds: animalIds)
        }
    }
}

struct AnimalGroupsDetail: View {
    var groupIds: Set<AnimalGroup.ID>
    @Binding var animalIds: Set<Animal.ID>
    
    var body: some View {
        List(Array(groupIds), id: \.self, selection: $animalIds) { id in
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

struct AnimalsDetail: View {
    var animalIds: Set<Animal.ID>
    
    var body: some View {
        List(Array(animalIds), id: \.self) { id in
            VStack(alignment: .leading) {
                Text(id)
                    .font(.headline)
                Text(getDescription(for: id))
            }
        }
    }
    
    func getDescription(for id: Animal.ID) -> String {
        for group in animalGroups {
            if let animal = group.animals.first(where: { $0.id == id}) {
                return animal.description
            }
        }
        return ""
    }
}

struct AnimalGroup: Identifiable {
    let name: String
    let animals: [Animal]
    
    var id: String { name }
}

struct Animal: Identifiable {
    let name: String
    let description: String
    
    var id: String { name }
}
