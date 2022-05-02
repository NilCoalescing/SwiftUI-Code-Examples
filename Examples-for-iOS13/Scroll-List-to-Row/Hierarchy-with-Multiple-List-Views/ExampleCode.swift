// Code for scrolling List to a row when
// there is more than one List view in the SwiftUI hierarchy.
//
// The idea is to have a class that can hold a reference
// to the table view in question (underlying UITableView of SwiftUI List view).
//
// Add a TableViewFinder view inside the List,
// which will find its parent UITableView and set a reference to it to the ScrollManager.
//
// Then add a ScrollManagerView to the List which
// will listen to indexPathToSetVisible binding changes and scroll to the correct row.
//
// This needs to be this way via a binding,
// we can't just call the `scrollTo(_ indexPath: IndexPath)` method directly,
// because it should be called when the table view was already updated with the new row.

import SwiftUI

extension UIView {
    func superview<T>(of type: T.Type) -> T? {
        if let result = superview as? T {
            if let scrollView = result as? UIScrollView {
                if scrollView.frame.height < 40 {
                    return superview?.superview(of: type)
                }
            }
            return result
        } else {
            return superview?.superview(of: type)
        }
    }
}

struct TableViewFinder: UIViewRepresentable {
    let scrollManager: ScrollManager
    
    func makeUIView(context: Context) -> ChildViewOfTableView {
        let view = ChildViewOfTableView()
        view.scrollManager = scrollManager
        
        return view
    }
    
    func updateUIView(_ uiView: ChildViewOfTableView, context: Context) {}
}

class ChildViewOfTableView: UIView {
    weak var scrollManager: ScrollManager?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if scrollManager?.tableView == nil {
            scrollManager?.tableView = self.superview(of: UITableView.self)
        }
    }
}

class ScrollManager {
    weak var tableView: UITableView?
    
    func scrollTo(_ indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let tableView = self?.tableView else { return }
            if tableView.numberOfSections > indexPath.section &&
                tableView.numberOfRows(inSection: indexPath.section) > indexPath.row
            {
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }

    }
}

struct ScrollManagerView: UIViewRepresentable {
    let scrollManager: ScrollManager
    
    @Binding var indexPathToSetVisible: IndexPath?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let indexPath = indexPathToSetVisible else { return }
        
        // The scrolling has to be inside this method,
        // because it gets called after the table view was already updated
        // with the new row.
        scrollManager.scrollTo(indexPath)
        
        DispatchQueue.main.async {
            self.indexPathToSetVisible = nil
        }
    }
}

struct ContentView: View {
    // ScrollManager keeps the reference to the table view
    // that needs to programmatically scroll
    let scrollManager = ScrollManager()
    @State var indexPathToSetVisible: IndexPath?
    
    @State var items = [
        "Item 1", "Item 2", "Item 3", "Item 4", "Item 5",
        "Item 6", "Item 7", "Item 8", "Item 9", "Item 10",
        "Item 11", "Item 12", "Item 13", "Item 14", "Item 15",
        "Item 16", "Item 17", "Item 18", "Item 19", "Item 20"
    ]
    
    var tableViewFinderOverlay: AnyView {
        // We only need to add one overlay view to find the parent table view,
        // we don't want an overlay view on each row.
        if scrollManager.tableView == nil {
            return AnyView(TableViewFinder(scrollManager: scrollManager))
        }
        return AnyView(EmptyView())
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Add") {
                    self.items.append("Item \(self.items.count + 1)")
                    
                    // Scroll to the newly added item.
                    // This needs to be this way via a binding,
                    // we can't just call the `scrollTo(_ indexPath: IndexPath)` method directly,
                    // because at this moment the table doesn't have the new row yet.
                    self.indexPathToSetVisible = IndexPath(row: self.items.count - 1, section: 0)
                }
                .padding()
            }
            
            Divider()
            
            HStack {
                // List that we don't need to programmatically scroll.
                List {
                    Text("Some Item 1")
                    Text("Some Item 2")
                }
                
                // List that we need to programmatically scroll.
                List {
                    ForEach(0..<self.items.count, id: \.self) { index in
                        Text(self.items[index])
                        .overlay(
                            // We need this to grab the reference to the table view
                            // that we want to programmatically scroll.
                            // The only way to add a child view to a List
                            // is to either add it to one of the rows or to insert an extra row.
                            self.tableViewFinderOverlay
                                .frame(width: 0, height: 0)
                        )
                    }
                }
                .overlay(
                    // the scrolling has to be done via the binding `indexPathToSetVisible`
                    ScrollManagerView(
                        scrollManager: scrollManager,
                        indexPathToSetVisible: $indexPathToSetVisible
                    )
                        .frame(width: 0, height: 0)
                )
            }
        }
    }
}
