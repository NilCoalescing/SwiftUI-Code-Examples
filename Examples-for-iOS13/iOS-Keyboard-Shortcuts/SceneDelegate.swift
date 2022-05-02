//
// Example code for article: https://nilcoalescing.com/blog/iOSKeyboardShortcutsInSwiftUI/
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let cityProvider = CityProvider()
        let contentView = ContentView(cityProvider: cityProvider)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let rootViewController = RootViewController(
                rootView: contentView, cityProvider: cityProvider
            )
            window.rootViewController = rootViewController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
