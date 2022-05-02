//
// Example code for article: https://nilcoalescing.com/blog/iOSKeyboardShortcutsInSwiftUI/
//

import SwiftUI

class RootViewController<Content: View>: UIHostingController<Content> {
    let cityProvider: CityProvider
    
    init(rootView: Content, cityProvider: CityProvider) {
        self.cityProvider = cityProvider
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var keyCommands: [UIKeyCommand]? {
        var result: [UIKeyCommand] = []
        
        if cityProvider.addedCities.count < cityProvider.cities.count {
            result.append(
                UIKeyCommand(
                    action: #selector(addCity), input: "N",
                    modifierFlags: [.shift, .command], discoverabilityTitle: "New City"
                )
            )
        }
        
        if cityProvider.addedCities.count > 1,
            let selectedIndex = cityProvider.selectedIndex {
            
            if selectedIndex > 0 {
                result.append(
                    UIKeyCommand(
                        action: #selector(selectPreviousCity),
                        input: UIKeyCommand.inputUpArrow,
                        modifierFlags: [.shift, .command],
                        discoverabilityTitle: "Select Previous City"
                    )
                )
            }
            
            if selectedIndex < cityProvider.addedCities.count - 1 {
                result.append(
                    UIKeyCommand(
                        action: #selector(selectNextCity),
                        input: UIKeyCommand.inputDownArrow,
                        modifierFlags: [.shift, .command],
                        discoverabilityTitle: "Select Next City"
                    )
                )
            }
        }
        
        if cityProvider.selectedCity != nil {
            result.append(
                UIKeyCommand(
                    action: #selector(deleteCity), input: "d",
                    modifierFlags: [.command],
                    discoverabilityTitle: "Delete City"
                )
            )
        }
        
        return result
    }
    
    @objc func addCity() {
        cityProvider.addCity()
    }
    
    @objc func selectPreviousCity() {
        if let selectedIndex = cityProvider.selectedIndex {
            let indexToSelect = selectedIndex - 1
            cityProvider.setSelected(index: indexToSelect)
        }
    }
    
    @objc func selectNextCity() {
        if let selectedIndex = cityProvider.selectedIndex {
            let indexToSelect = selectedIndex + 1
            cityProvider.setSelected(index: indexToSelect)
        }
    }
    
    @objc func deleteCity() {
        if let selectedCity = cityProvider.selectedCity {
            cityProvider.deleteCity(selectedCity)
        }
    }
}

extension UIKeyCommand {
    convenience init(
        action: Selector, input: String,
        modifierFlags: UIKeyModifierFlags, discoverabilityTitle: String
    ) {
        self.init(
            title: "", image: nil, action: action, input: input,
            modifierFlags: modifierFlags, propertyList: nil,
            alternates: [], discoverabilityTitle: discoverabilityTitle,
            attributes: [], state: .on
        )
    }
}
