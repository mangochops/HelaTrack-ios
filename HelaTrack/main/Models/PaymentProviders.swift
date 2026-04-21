//
//  PaymentProviders.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI


struct PaymentProvider: Identifiable {
    let id = UUID()
    let name: String
    let identifierLabel: String
    let logo: Image
    let brandColor: Color
}



struct PaymentMethods {
    static let providers = [
        PaymentProvider(
            name: "M-Pesa",
            identifierLabel: "Phone Number",
            logo: Image.mpesaLogo,
            brandColor: Color.brandsafaricom
        ),
        PaymentProvider(
            name: "M-Pesa Till",
            identifierLabel: "Till Number",
            logo: Image.mpesaMerchantLogo,
            brandColor: Color.brandsafaricom
        ),
        PaymentProvider(
            name: "M-Pesa Paybill",
            identifierLabel: "Paybill Number",
            logo: Image.mpesaMerchantLogo,
            brandColor: Color.brandsafaricom
        ),
        PaymentProvider(
            name: "Airtel Money",
            identifierLabel: "Phone Number",
            logo: Image.airtelLogo,
            brandColor: Color.brandairtel
        ),
        PaymentProvider(
            name: "Equity Bank",
            identifierLabel: "Last 4 Digits of Account",
            logo: Image.equityLogo,
            brandColor: Color.brandequity
        ),
        PaymentProvider(
            name: "Family Bank",
            identifierLabel: "Last 4 Digits of Account",
            logo: Image.familyBankLogo,
            brandColor: Color.brandfamilyBank
        ),
        PaymentProvider(
            name: "NCBA Bank",
            identifierLabel: "Last 4 Digits of Account",
            logo: Image.ncbaLogo,
            brandColor: Color.brandncba
        ),
        PaymentProvider(
            name: "ABSA Bank",
            identifierLabel: "Last 4 Digits of Account",
            logo: Image.absaLogo,
            brandColor: Color.brandabsa
        ),
    ]
}
