//
//  TaskRowView.swift
//  ToDoListSwiftUI
//
//  Created by Kevin on 30/06/2025.
//


import SwiftUI

struct TaskRowView: View {
    let task: Task
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingEditTask = false
    
    var body: some View {
        HStack {
            Button(action: { viewModel.toggleCompletion(task) }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                    .strikethrough(task.isCompleted)
                Text("Due: \(task.dueDate ?? Date(), formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Circle()
                .fill(TaskPriority(rawValue: task.priority ?? "Low")?.color ?? .gray)
                .frame(width: 12, height: 12)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.1))
                .shadow(color: .black.opacity(0.2), radius: 5, x: -5, y: -5)
                .shadow(color: .white.opacity(0.3), radius: 5, x: 5, y: 5)
        )
        .onTapGesture { showingEditTask = true }
        .sheet(isPresented: $showingEditTask) {
            AddTaskView(viewModel: viewModel, task: task)
        }
        .contextMenu {
            Button(role: .destructive) {
                viewModel.deleteTask(task)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}