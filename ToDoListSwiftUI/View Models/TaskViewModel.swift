//
//  TaskViewModel.swift
//  ToDoListSwiftUI
//
//  Created by Kevin on 30/06/2025.
//


import SwiftUI
import CoreData
import UserNotifications

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchTasks()
        requestNotificationPermission()
    }
    
    // MARK: - Core Data Operations
    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.createdAt, ascending: false)]
        do {
            tasks = try viewContext.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    func addTask(title: String, category: TaskCategory, dueDate: Date, priority: TaskPriority) {
        let newTask = Task(context: viewContext)
        newTask.id = UUID()
        newTask.title = title
        newTask.category = category.rawValue
        newTask.dueDate = dueDate
        newTask.priority = priority.rawValue
        newTask.isCompleted = false
        newTask.createdAt = Date()
        
        saveContext()
        scheduleNotification(for: newTask)
        fetchTasks()
    }
    
    func updateTask(_ task: Task, title: String, category: TaskCategory, dueDate: Date, priority: TaskPriority) {
        task.title = title
        task.category = category.rawValue
        task.dueDate = dueDate
        task.priority = priority.rawValue
        
        saveContext()
        scheduleNotification(for: task)
        fetchTasks()
    }
    
    func toggleCompletion(_ task: Task) {
        task.isCompleted.toggle()
        saveContext()
        fetchTasks()
    }
    
    func deleteTask(_ task: Task) {
        viewContext.delete(task)
        saveContext()
        fetchTasks()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // MARK: - Notifications
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    private func scheduleNotification(for task: Task) {
        guard let title = task.title, let dueDate = task.dueDate, !task.isCompleted else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Your task '\(title)' is due!"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id!.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    // MARK: - UserDefaults for Settings
    func saveLastCategory(_ category: TaskCategory) {
        UserDefaults.standard.set(category.rawValue, forKey: "lastCategory")
    }
    
    func getLastCategory() -> TaskCategory {
        let category = UserDefaults.standard.string(forKey: "lastCategory") ?? TaskCategory.work.rawValue
        return TaskCategory(rawValue: category) ?? .work
    }
}