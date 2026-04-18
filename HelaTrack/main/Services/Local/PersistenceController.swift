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
    
    // In PersistenceController.swift
    func seedTestData() {
        let mockSMS = [
            "SJK71234XX Confirmed. Ksh 1,300.00 received from Villa Rosa on 15/4/26",
            "RK923456YY Confirmed. Ksh 2,500.00 received from NJERI on 15/4/26",
            "ID: T23456789 Confirmed. Amount: KES 4,200.00 from KCB BANK on 16/4/26"
        ]
        
        for body in mockSMS {
            // Use your existing parser logic
            if let entity = MessageParser.parse(sender: "MPESA", body: body) {
                saveTransaction(entity) // Your method to save to Core Data
            }
        }
    }
}
