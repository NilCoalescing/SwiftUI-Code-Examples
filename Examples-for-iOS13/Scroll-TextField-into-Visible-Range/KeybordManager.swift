//
// Example code for article: https://nilcoalescing.com/blog/ScrollTextFieldIntoVisibleRange/
//

import SwiftUI

class KeybordManager: ObservableObject {
    static let shared = KeybordManager()

    @Published var keyboardFrame: CGRect? = nil
    
    init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(willHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc func willHide() {
        self.keyboardFrame = .zero
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        self.keyboardFrame = keyboardScreenEndFrame
    }
}
