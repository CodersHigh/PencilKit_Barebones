//
//  DrawingViewModel.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/27.
//

import Foundation
import CoreData
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var drawings = [Drawing]()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "DrawingModel")
        persistentContainer.loadPersistentStores { (descripiton, error) in
            if let error = error {
                fatalError("Core Data Store failed: \(error.localizedDescription)")
            }
        }
    }
    
    func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    func deleteDrawing(drawing: Drawing) {
        persistentContainer.viewContext.delete(drawing)
        saveContext()
    }
    
    func fetchDrawing() {
        let fetchRequest: NSFetchRequest<Drawing> = Drawing.fetchRequest()
        
        do {
            try self.drawings = persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch drawing: \(error.localizedDescription)")
        }
    }
    
    func addDrawing(title: String) {
        let drawing = Drawing(context: persistentContainer.viewContext)
        drawing.title = title
        drawing.data = PKDrawing().dataRepresentation()
        drawing.id = UUID()
        saveContext()
    }
    
}
