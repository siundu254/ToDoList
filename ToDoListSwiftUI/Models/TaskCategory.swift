//
//  TaskCategory.swift
//  ToDoListSwiftUI
//
//  Created by Kevin on 30/06/2025.
//


import Foundation
import SwiftUI

enum TaskCategory: String, CaseIterable, Identifiable {
    case work = "Work"
    case personal = "Personal"
    case other = "Other"
    
    var id: String { rawValue }
}

enum TaskPriority: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var id: String { rawValue }
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}
