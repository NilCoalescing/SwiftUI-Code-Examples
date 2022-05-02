//
// Example code for article: https://nilcoalescing.com/blog/iOSKeyboardShortcutsInSwiftUI/
//
// The text in this code uses material from the Wikipedia articles:
// https://en.wikipedia.org/wiki/Auckland,
// https://en.wikipedia.org/wiki/Wellington,
// https://en.wikipedia.org/wiki/Christchurch,
// https://en.wikipedia.org/wiki/Dunedin,
// https://en.wikipedia.org/wiki/Hamilton,_New_Zealand,
// which are released under the Creative Commons Attribution-Share-Alike License 3.0
// (https://creativecommons.org/licenses/by-sa/3.0/).
//

import Foundation

struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
}

class CityProvider: ObservableObject {
    let cities: Set<City> = [
        City(name: "Auckland", description: "Auckland (/ˈɔːklənd/ AWK-lənd) is a city in the North Island of New Zealand. The most populous urban area in the country, Auckland has an urban population of about 1,570,100 (June 2018).[4] It is located in the Auckland Region—the area governed by Auckland Council—which includes outlying rural areas and the islands of the Hauraki Gulf, resulting in a total population of 1,618,400."),
        City(name: "Wellington", description: "Wellington (Māori: Te Whanganui-a-Tara [tɛ ˈfaŋanʉi a taɾa]) is the capital city and second-most populous urban area of New Zealand, with 418,500 residents (as at 2019).[3] It is located at the south-western tip of the North Island, between Cook Strait and the Remutaka Range."),
        City(name: "Christchurch", description: "Christchurch (/ˈkraɪstʃɜːrtʃ/; Māori: Ōtautahi) is the largest city in the South Island of New Zealand and the seat of the Canterbury Region. The Christchurch urban area lies on the South Island's east coast, just north of Banks Peninsula."),
        City(name: "Dunedin", description: "Dunedin (/dʌˈniːdɪn/ (About this soundlisten)[7] duh-NEE-din; Māori: Ōtepoti) is the second-largest city in the South Island of New Zealand (after Christchurch), and the principal city of the Otago region. Its name comes from Dùn Èideann, the Scottish Gaelic name for Edinburgh, the capital of Scotland."),
        City(name: "Hamilton", description: "Hamilton (Māori: Kirikiriroa) is a city in the North Island of New Zealand. It is the seat and most populous city of the Waikato region, with a territorial population of 169,300,[3] the country's fourth most-populous city.") 
    ]
    
    @Published var addedCities: [City] = []
    @Published var selectedCity: City? = nil
    
    var selectedIndex: Int? {
        if let selectedCity = selectedCity {
            return addedCities.firstIndex(of: selectedCity)
        }
        
        return nil
    }
    
    func addCity() {
        let citiesToAdd = cities.subtracting(addedCities)
        
        if let cityToAdd = citiesToAdd.randomElement() {
            addedCities.append(cityToAdd)
            selectedCity = cityToAdd
        }
    }
    
    func setSelected(index: Int) {
        if (0...addedCities.count).contains(index) {
            selectedCity = addedCities[index]
        }
    }
    
    func deleteCity(_ city: City) {
        guard let indexToDelete = addedCities.firstIndex(of: city) else { return }
        
        addedCities.remove(at: indexToDelete)
        
        if city != selectedCity { return }
        
        if indexToDelete == 0, let firstCity = addedCities.first {
            selectedCity = firstCity
        } else if !addedCities.isEmpty {
            selectedCity = addedCities[indexToDelete - 1]
        } else {
            selectedCity = nil
        }
    }
}
