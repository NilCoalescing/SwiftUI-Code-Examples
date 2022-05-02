//
//  Dismiss.swift
//  SplitViewDocumentApp
//
//  Created by Matthaus Woolard on 18/01/2021.
//

import SwiftUI

#if canImport(UIKit)

struct DismissDocumentButton: View {
    
    @Environment(\.dismiss)
    var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Label("Close", systemImage: "folder")
        }
    }
}

struct DismissDocumentButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissDocumentButton()
    }
}


struct DismissingView: UIViewRepresentable {
        
    let dismiss: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if dismiss {
            DispatchQueue.main.async {
                view.dismissViewControler()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if dismiss {
            DispatchQueue.main.async {
                uiView.dismissViewControler()
            }
        }
    }
}


extension UIResponder {
    func dismissViewControler() {
        guard let vc = self as? UIViewController else {
            self.next?.dismissViewControler()
            return
        }
        vc.dismiss(animated: true)
    }
}


struct DismissModifier: ViewModifier {
    @State
    var dismiss = false
    
    func body(content: Content) -> some View {
        content.background(
            DismissingView(dismiss: dismiss)
        ).environment(
            \.dismiss,
            {
                self.dismiss = true
            }
        )
    }
}

struct DismissEnvironmentKey: EnvironmentKey {
    static var defaultValue: () -> Void {
        {}
    }
    
    typealias Value = () -> Void
}

extension EnvironmentValues {
    var dismiss: DismissEnvironmentKey.Value {
        get {
            self[DismissEnvironmentKey.self]
        }
        
        set {
            self[DismissEnvironmentKey.self] = newValue
        }
    }
}

#endif
