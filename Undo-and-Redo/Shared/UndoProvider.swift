//
//  UndoProvider.swift
//  UndoProvider
//
//  Created by Matthaus Woolard on 09/09/2020.
//

import SwiftUI

class UndoHandler<Value>: ObservableObject {
    var binding: Binding<Value>?
    weak var undoManger: UndoManager?
    
    func registerUndo(from oldValue: Value, to newValue: Value) {
        undoManger?.registerUndo(withTarget: self) { handler in
            handler.registerUndo(from: newValue, to: oldValue)
            handler.binding?.wrappedValue = oldValue
        }
    }
    
    init() {}
}


struct UndoProvider<WrappedView, Value>: View where WrappedView: View {
    
    @Environment(\.undoManager)
    var undoManager
    
    @StateObject
    var handler: UndoHandler<Value> = UndoHandler()
    
    var wrappedView: (Binding<Value>) -> WrappedView
    
    //
    var binding: Binding<Value>
    
    init(_ binding: Binding<Value>, @ViewBuilder wrappedView: @escaping (Binding<Value>) -> WrappedView) {
        self.binding = binding
        self.wrappedView = wrappedView
    }
    
    var interceptedBinding: Binding<Value> {
        Binding {
            self.binding.wrappedValue
        } set: { newValue in
            self.handler.registerUndo(from: self.binding.wrappedValue, to: newValue)
            self.binding.wrappedValue = newValue
        }
    }
    
    var body: some View {
        wrappedView(self.interceptedBinding).onAppear {
            self.handler.binding = self.binding
            self.handler.undoManger = self.undoManager
        }.onChange(of: self.undoManager) { undoManager in
            self.handler.undoManger = undoManager
        }
    }
}


struct UndoProvider_Previews: PreviewProvider {
    static var previews: some View {
        UndoProvider(.constant(1)) { binding in
            Text("Hello")
        }
    }
}
