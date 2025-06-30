//
//  Persistence.swift
//  ToDoListSwiftUI
//
//  Created by Kevin on 30/06/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Sample data for preview
        for i in 0..<10 {
            let newTask = Task(context: viewContext)
            newTask.id = UUID()
            newTask.title = "Task \(i + 1)"
            newTask.category = TaskCategory.allCases.randomElement()?.rawValue ?? TaskCategory.work.rawValue
            newTask.dueDate = Date().addingTimeInterval(Double(i * 3600)) // Spread due dates
            newTask.priority = TaskPriority.allCases.randomElement()?.rawValue ?? TaskPriority.low.rawValue
            newTask.isCompleted = Bool.random()
            newTask.createdAt = Date()
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving preview data: \(error)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoListSwiftUI") // Match the .xcdatamodeld file name
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                print("Error loading persistent stores: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
