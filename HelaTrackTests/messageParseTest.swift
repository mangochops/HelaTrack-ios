import XCTest
@testable import HelaTrack

final class MessageParserTests: XCTestCase {
    
    func testMpesaReceived() {
        let body = "SJK71234XX Confirmed. Ksh 1,000.00 received from WANGUI on 15/4/26 at 3:21 PM"
        let result = MessageParser.parse(sender: "MPESA", body: body)
        
        XCTAssertNotNil(result, "Parser failed to handle M-Pesa Received message")
        XCTAssertEqual(result?.amount, 1000.0)
        XCTAssertEqual(result?.ref, "SJK71234XX")
        XCTAssertEqual(result?.person, "WANGUI")
    }
    
//    func testMpesaMerchantPayment() {


    func testAirtelMoney() {
        let body = "ID: 123456789. Amount: KES 2,500.00 from AIRTEL-CASH on 15/4/26."
        let result = MessageParser.parse(sender: "AIRTEL", body: body)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.ref, "123456789")
        XCTAssertEqual(result?.category, "AIRTEL")
    }

    func testBankAlert() {
        let body = "KES 1,300.00 by Villa Rosa on 15/4/26."
        // Testing with an Equity Bank shortcode
        let result = MessageParser.parse(sender: "247247", body: body)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.amount, 1300.0)
        XCTAssertEqual(result?.category, "BANK")
        XCTAssertTrue(result!.ref.contains("EQ-BNK-"), "Bank reference should have the correct prefix")
    }
}
