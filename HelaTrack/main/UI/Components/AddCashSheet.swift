//
//  AddCashSheet.swift
//  HelaTrack
//
//  Created by mac on 4/18/26.
//

import SwiftUI

struct AddCashTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State private var amount: String = ""
    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Amount (KES)", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Note (e.g. Sales)", text: $note)
                }
                
                Button(action: saveTransaction) {
                    Text("Save Cash Sale")
                        .frame(maxWidth: .infinity)
                        .bold()
                }
                .listRowBackground(Color.brandsafaricom) // Consistent brand color
                .foregroundColor(.white)
            }
            .navigationTitle("Add Cash Sale")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    func saveTransaction() {
        let newTransaction = Transaction(context: viewContext)
        newTransaction.amount = Double(amount) ?? 0.0
        newTransaction.timestamp = Date()
        
        // This is the CRITICAL line for your HomeView filters to work
        newTransaction.category = "Cash"
        
       

        do {
            try viewContext.save()
            dismiss() // Close the sheet
        } catch {
            print("Error saving: \(error)")
        }
    }
    
}
