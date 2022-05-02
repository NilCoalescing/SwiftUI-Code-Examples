//
// Example code for article: https://nilcoalescing.com/blog/ScrollTextFieldIntoVisibleRange/
//
// A custom view wrapping UITextField for SwiftUI usage
// and a UITextField subclass that adjusts for keyboard.
//

import SwiftUI
import Combine

struct TextFieldWithKeyboardObserver: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    
    func makeUIView(context: Context) -> UITextField {
        let view = UITextFieldWithKeyboardObserver()
        view.delegate = context.coordinator
        view.text = text
        view.placeholder = placeholder
        view.setupKeyboardObserver()
        
        return view
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldWithKeyboardObserver
        var didBecomeFirstResponder = false
        
        init(parent: TextFieldWithKeyboardObserver) {
            self.parent = parent
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let parentScrollView = textField.superview(of: UIScrollView.self) {
                if !(parentScrollView.currentFirstResponder() is UITextFieldWithKeyboardObserver) {
                    parentScrollView.contentInset = .zero
                }
            }
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textField.text ?? ""
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(true)
            return true
        }
        
    }
}

class UITextFieldWithKeyboardObserver: UITextField {
    private var keyboardPublisher: AnyCancellable?
    
    func setupKeyboardObserver() {
        keyboardPublisher = KeybordManager.shared.$keyboardFrame
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keyboardFrame in
                
                if let strongSelf = self, let keyboardFrame = keyboardFrame  {
                    strongSelf.update(with: keyboardFrame)
                }
        }
    }
    
    private func update(with keyboardFrame: CGRect) {
        if let parentScrollView = superview(of: UIScrollView.self), isFirstResponder {
            
            let keyboardFrameInScrollView = parentScrollView
                .convert(keyboardFrame, from: UIScreen.main.coordinateSpace)
            
            let scrollViewIntersection = parentScrollView.bounds
                .intersection(keyboardFrameInScrollView).height

            let contentInsets = UIEdgeInsets(
                top: 0.0, left: 0.0,
                bottom: scrollViewIntersection, right: 0.0
            )
            
            parentScrollView.contentInset = contentInsets
            parentScrollView.scrollIndicatorInsets = contentInsets
            
            parentScrollView.scrollRectToVisible(frame, animated: true)
        }
    }
}
