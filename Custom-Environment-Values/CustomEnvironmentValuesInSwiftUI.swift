//
// Example code for article: https://nilcoalescing.com/blog/CustomEnvironmentValuesInSwiftUI/
//

import SwiftUI

extension EnvironmentValues {
    @Entry var favoriteColor: Color = .blue
}

extension View {
    func favoriteColor(_ color: Color) -> some View {
        environment(\.favoriteColor, color)
    }
}

struct ContentView: View {
    @State private var favoriteColor: Color = .blue
    
    var body: some View {
        NavigationStack {
            TodoList()
                .toolbar {
                    ColorPicker(
                        "Favorite color",
                        selection: $favoriteColor
                    )
                    .labelsHidden()
                }
        }
        .favoriteColor(favoriteColor)
    }
}

struct Task: Identifiable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
}

struct TodoList: View {
    @State private var tasks = [
        Task(title: "Write a blog post", isCompleted: false),
        Task(title: "Review pull requests", isCompleted: false),
        Task(title: "Update documentation", isCompleted: false)
    ]
    
    var body: some View {
        List($tasks) { task in
            TodoTaskRow(task: task)
        }
    }
}

struct TodoTaskRow: View {
    @Binding var task: Task
    
    var body: some View {
        Button {
            task.isCompleted.toggle()
        } label: {
            HStack {
                Text(task.title)
                Spacer()
                if task.isCompleted {
                    TaskCheckmark()
                }
            }
        }
        .foregroundStyle(.primary)
    }
}

struct TaskCheckmark: View {
    @Environment(\.favoriteColor)
    private var favoriteColor
    
    var body: some View {
        Image(systemName: "checkmark")
            .foregroundStyle(favoriteColor)
    }
}
