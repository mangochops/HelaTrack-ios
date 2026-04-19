import Foundation
import PDFKit
import UIKit

class PDFManager {
    static func createTransactionReport(transactions: [Transaction]) -> Data {
        // Standard metadata to avoid CoreGraphics scope issues
        let pdfMetaData: [String: Any] = [
            kCGPDFContextTitle as String: "HelaTrack Report",
            kCGPDFContextAuthor as String: "HelaTrack",
            kCGPDFContextSubject as String: "Transaction Summary"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData

        // A4 Paper Size: 8.27 x 11.69 inches (at 72 DPI)
        let pageWidth = 8.27 * 72.0
        let pageHeight = 11.69 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        return renderer.pdfData { (context) in
            context.beginPage()
            
            // --- TITLE ---
            let title = "HelaTrack Transaction Report"
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            title.draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttributes)
            
            var cursorY: CGFloat = 100
            
            // --- TABLE HEADERS ---
            let headerFont = UIFont.boldSystemFont(ofSize: 12)
            let headers = [("Date", 50), ("Customer", 150), ("Amount (KES)", 450)]
            
            for (text, xPos) in headers {
                text.draw(at: CGPoint(x: CGFloat(xPos), y: cursorY), withAttributes: [.font: headerFont])
            }
            
            cursorY += 20
            
            // --- CONTENT ROWS ---
            let rowFont = UIFont.systemFont(ofSize: 10)
            for tx in transactions {
                // Page break logic
                if cursorY > pageHeight - 50 {
                    context.beginPage()
                    cursorY = 50
                }
                
                let dateStr = tx.timestamp?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
                let nameStr = tx.person ?? "General Collection"
                let amountStr = "KES \(Int(tx.amount))"
                
                dateStr.draw(at: CGPoint(x: 50, y: cursorY), withAttributes: [.font: rowFont])
                nameStr.draw(at: CGPoint(x: 150, y: cursorY), withAttributes: [.font: rowFont])
                amountStr.draw(at: CGPoint(x: 450, y: cursorY), withAttributes: [.font: rowFont])
                
                cursorY += 25
            }
        }
    }
}
