//
//  AddTaskView.swift
//  ToDoListSwiftUI
//
//  Created by Kevin on 30/06/2025.
//


import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var category: TaskCategory = .work
    @State private var dueDate = Date()
    @State private var priority: TaskPriority = .low
    var task: Task?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $title)
                    Picker("Category", selection: $category) {
                        ForEach(TaskCategory.allCases) { category in
                            Text(category.rawValue).tag(category)

                        }
                    }
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Due Date", selection: $dueDate, in: Date()...)
                        .datePickerStyle(.graphical)
                }
            }
            .navigationTitle(task == nil ? "New Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let task = task {
                            viewModel.updateTask(task, title: title, category: category, dueDate: dueDate, priority: priority)
                        } else {
                            viewModel.addTask(title: title, category: category, dueDate: dueDate, priority: priority)
                        }
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .onAppear {
                if let task = task {
                    title = task.title ?? ""
                    category = TaskCategory(rawValue: task.category ?? "Work") ?? .work
                    dueDate = task.dueDate ?? Date()
                    priority = TaskPriority(rawValue: task.priority ?? "Low") ?? .low
                }
            }
        }
        .accentColor(.purple)
    }
}