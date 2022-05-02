//
// Example code for article: https://nilcoalescing.com/blog/ScrollTextFieldIntoVisibleRange/
//
// An extension to UIView to find an active first responder among children.
//

import UIKit

extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
     }
}
