//
//  PaymentModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 19/03/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct PaymentModel: Codable {
    let code: Int?
    let message: String?
    let body: PaymentBody?
}

// MARK: - Body
struct PaymentBody: Codable {
    let id, acHolderName, bankName, routingNo: String?
    let accountNo, branchIFSC, branchName, empID: String?
    let companyID, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, acHolderName, bankName, routingNo, accountNo, branchIFSC, branchName
        case empID = "empId"
        case companyID = "companyId"
        case createdAt, updatedAt
    }
}
