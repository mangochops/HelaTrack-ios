import Foundation
import PDFKit
import UIKit

class PDFManager {
    static func createTransactionReport(transactions: [Transaction]) -> Data {
        let pdfMetaData: [String: Any] = [
            kCGPDFContextTitle as String: "HelaTrack Report",
            kCGPDFContextAuthor as String: "HelaTrack"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData

        let pageWidth = 8.27 * 72.0
        let pageHeight = 11.69 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        // --- CALCULATIONS ---
        let totalAmount = transactions.reduce(0) { $0 + $1.amount }
        // Assuming your Transaction model has an 'isCash' or 'type' property
        let cashSubtotal = transactions.filter { $0.category == "Cash" }.reduce(0) { $0 + $1.amount }
        let digitalSubtotal = transactions.filter { $0.category == "Digital" }.reduce(0) { $0 + $1.amount }
        
        // Get Month Name from first transaction
        let reportMonth = transactions.first?.timestamp?.formatted(.dateTime.month(.wide)) ?? "Monthly"

        return renderer.pdfData { (context) in
            context.beginPage()
            
            // --- LOGO ---
            if let logo = UIImage(named: "AppIcon") {
                logo.draw(in: CGRect(x: pageWidth - 100, y: 35, width: 50, height: 50))
            }
            
            // --- TITLE & MONTH ---
            let title = "HelaTrack: \(reportMonth) Report"
            title.draw(at: CGPoint(x: 50, y: 50), withAttributes: [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ])
            
            // --- SUMMARY SECTION ---
            var cursorY: CGFloat = 110
            let summaryFont = UIFont.systemFont(ofSize: 12)
            let summaries = [
                "Digital Subtotal: KES \(Int(digitalSubtotal))",
                "Cash Subtotal: KES \(Int(cashSubtotal))",
                "Total Collection: KES \(Int(totalAmount))"
            ]
            
            for text in summaries {
                text.draw(at: CGPoint(x: 50, y: cursorY), withAttributes: [.font: summaryFont])
                cursorY += 18
            }
            
            cursorY += 20 // Space before table
            
            // --- TABLE HEADERS ---
            let headerFont = UIFont.boldSystemFont(ofSize: 11)
            // Column positions: Date(50), Customer(130), Type(350), Amount(460)
            let headers = [("Date", 50), ("Customer", 130), ("Method", 350), ("Amount (KES)", 460)]
            
            for (text, xPos) in headers {
                text.draw(at: CGPoint(x: CGFloat(xPos), y: cursorY), withAttributes: [.font: headerFont])
            }
            
            cursorY += 20
            
            // --- CONTENT ROWS ---
            let rowFont = UIFont.systemFont(ofSize: 10)
            for tx in transactions {
                if cursorY > pageHeight - 70 {
                    context.beginPage()
                    cursorY = 50
                }
                
                let dateStr = tx.timestamp?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
                let nameStr = tx.person ?? "General Collection"
                let typeStr = tx.category ?? "Unknown"
                let amountStr = "KES \(Int(tx.amount))"
                
                dateStr.draw(at: CGPoint(x: 50, y: cursorY), withAttributes: [.font: rowFont])
                nameStr.draw(at: CGPoint(x: 130, y: cursorY), withAttributes: [.font: rowFont])
                typeStr.draw(at: CGPoint(x: 350, y: cursorY), withAttributes: [.font: rowFont])
                amountStr.draw(at: CGPoint(x: 460, y: cursorY), withAttributes: [.font: rowFont])
                
                cursorY += 22
            }
            
            // --- FINAL TOTAL LINE ---
            let footerTop = cursorY + 10
            context.cgContext.setStrokeColor(UIColor.lightGray.cgColor)
            context.cgContext.move(to: CGPoint(x: 50, y: footerTop))
            context.cgContext.addLine(to: CGPoint(x: pageWidth - 50, y: footerTop))
            context.cgContext.strokePath()
            
            let finalTotalStr = "Grand Total: KES \(Int(totalAmount))"
            finalTotalStr.draw(at: CGPoint(x: 400, y: footerTop + 10), withAttributes: [
                .font: UIFont.boldSystemFont(ofSize: 12)
            ])
        }
    }
}
