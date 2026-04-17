//
//  PersistenceController.swift
//  HelaTrack
//
//  Created by mac on 4/17/26.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "HelaTrack") // Ensure this matches your .xcdatamodeld name
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // Equivalent to DAO Methods
    func saveTransaction(_ entity: TransactionEntity) {
        let context = container.viewContext
        let transaction = Transaction(context: context) // Core Data Generated Class
        transaction.ref = entity.ref
        transaction.amount = entity.amount
        transaction.person = entity.person
        transaction.category = entity.category
        transaction.timestamp = entity.timestamp
        transaction.rawMessage = entity.rawMessage

        do {
            try context.save()
        } catch {
            print("Failed to save transaction: \(error)")
        }
    }
}
