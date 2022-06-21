//
//  TermsCondition.swift
//  DriverDeliveryApp
//
//  Created by Sumeet Pal on 24/03/22.
//  Copyright © 2022 Navaldeep Kaur. All rights reserved.
//


import Foundation

// MARK: - Welcome
struct TermsCondtion: Codable {
    let code: Int?
    let message: String?
    let body: TermsCondtion_Body?
}

// MARK: - Body
struct TermsCondtion_Body: Codable {
    let id, aboutus: String?
    let aboutusLink: String?
    let privacyContent, termsContent: String?
    let termsLink, privacyLink: String?
    let cancellationLink: String?
    let cancellationPolicy: String?
}
