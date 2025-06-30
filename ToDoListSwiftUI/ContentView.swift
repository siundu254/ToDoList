//
//  ContentView.swift
//  ToDoListSwiftUI
//
//  Created by Kevin on 30/06/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: TaskViewModel
    @State private var showingAddTask = false
    @State private var selectedCategory: TaskCategory = .work
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TaskViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Category Picker
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(TaskCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: -5, y: -5)
                            .shadow(color: .white.opacity(0.3), radius: 5, x: 5, y: 5)
                    )
                    .padding(.top)
                    
                    // Task List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.tasks.filter {
                                $0.category == selectedCategory.rawValue
                            }) { task in
                                TaskRowView(task: task, viewModel: viewModel)
                                    .transition(.scale)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("To-Do List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(viewModel: viewModel)
            }
            .onChange(of: selectedCategory) { newValue in
                viewModel.saveLastCategory(newValue)
            }
            .onAppear {
                selectedCategory = viewModel.getLastCategory()
            }
        }
        .accentColor(.white)
    }
}
