//
//  ToDoListSwiftUIApp.swift
//  ToDoListSwiftUI
//
//  Created by Kevin on 30/06/2025.
//

import SwiftUI

@main
struct ToDoListSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
