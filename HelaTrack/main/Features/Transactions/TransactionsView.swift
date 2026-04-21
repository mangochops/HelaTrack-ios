//
//  TransactionsView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct PDFShareItem: Identifiable {
    let id = UUID()
    let data: Data
}

struct TransactionsView: View {
    @State private var searchQuery = ""
    @State private var selectedFilter: TimeFilter = .all
    @State private var pdfData: Data?
    @State private var isSharing = false
    @State private var pdfToShare: PDFShareItem?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.timestamp, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<Transaction>
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 16) {
                    // --- SEARCH & FILTERS ---
                    VStack(spacing: 12) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search by name or reference...", text: $searchQuery)
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Horizontal Filter Chips (LazyRow equivalent)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(TimeFilter.allCases, id: \.self) { filter in
                                    FilterChip(
                                        label: filter.rawValue,
                                        isSelected: selectedFilter == filter
                                    ) {
                                        selectedFilter = filter
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // --- TRANSACTION LIST ---
                    ScrollView {
                        LazyVStack(spacing: 8, pinnedViews: [.sectionHeaders]) {
                                // 1. Group transactions by the start of the day
                                let groupedByDay = Dictionary(grouping: filteredTransactions) { (tx: Transaction) -> Date in
                                    Calendar.current.startOfDay(for: tx.timestamp ?? Date())
                                }
                                
                                // 2. Sort the days (most recent first)
                                let sortedDays = groupedByDay.keys.sorted(by: >)

                                ForEach(sortedDays, id: \.self) { date in
                                    // 3. Create a section for each day
                                    Section(header: DailyTotalHeader(date: date, transactions: groupedByDay[date] ?? [])) {
                                        ForEach(groupedByDay[date] ?? [], id: \.self) { transaction in
                                            TransactionRow(transaction: transaction)
                                        }
                                    }
                                }
                            }
                        
                        .padding(.horizontal)
                    }
                    .refreshable {
                        // This allows the user to manually trigger a refresh
                        // Even with @FetchRequest, it provides a "Manual Sync" feel
                        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1-second delay for feedback
                        print("Transactions refreshed")
                    }
                }
                
                // --- FLOATING ACTION BUTTON ---
                Button(action: { self.exportToPDF() }) {
                    Label("Export PDF", systemImage: "doc.plaintext.fill")
                        .font(.subheadline.bold())
                        .padding()
                        .background(Color(red: 0.05, green: 0.1, blue: 0.2)) // Dark brand color
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                }
                .padding(24)
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.secondary.opacity(0.05).ignoresSafeArea())
            .sheet(item: $pdfToShare) { item in
                            ShareSheet(activityItems: [item.data])
                        }
        }
        
        
    }
    
    private func exportToPDF() {
            let data = PDFManager.createTransactionReport(transactions: Array(filteredTransactions))
            if !data.isEmpty {
                self.pdfToShare = PDFShareItem(data: data)
            }
        }
    
    private var filteredTransactions: [Transaction] {
        // 1. Apply Time Filter
        let dateFiltered = transactions.filter { tx in
            guard let txDate = tx.timestamp, let startLimit = selectedFilter.startDate() else {
                return true // If filter is 'All', return everything
            }
            return txDate >= startLimit
        }
        
        // 2. Apply Search Query on top of date filtering
        if searchQuery.isEmpty {
            return dateFiltered
        } else {
            return dateFiltered.filter {
                ($0.person ?? "").localizedCaseInsensitiveContains(searchQuery) ||
                ($0.ref ?? "").localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct DailyTotalHeader: View {
    let date: Date
    let transactions: [Transaction]
    
    var dailyTotal: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        HStack {
            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline.bold())
                .foregroundColor(.secondary)
            Spacer()
            Text("Daily Total: KES \(Int(dailyTotal))")
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.accentColor.opacity(0.1))
                .foregroundColor(.accentColor)
                .clipShape(Capsule())
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground).opacity(0.95)) // Background for pinned header
    }
}
