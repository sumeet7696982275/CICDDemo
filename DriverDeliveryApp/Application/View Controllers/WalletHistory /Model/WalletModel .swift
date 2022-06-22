//
//  WalletModel .swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/11/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//


import Foundation


// MARK: - WalletModel
struct WalletModel: Codable {
    let code: Int
    let message: String
    let body: WalletData
}

// MARK: - Body
struct WalletData: Codable {
    let data: [WalletBody]?
    let balance: RelaxedString?
}

// MARK: - Datum
struct WalletBody: Codable {
    let id, amount, companyID, empID: String?
    let orderID: String?
    let payType: Int?
    let createdAt, updatedAt: String?
    let purpose: String?
    let order: OrderDetail?

    enum CodingKeys: String, CodingKey {
        case id, amount
        case companyID = "companyId"
        case empID = "empId"
        case orderID = "orderId"
        case payType, createdAt, updatedAt, order
        case purpose
    }
}

// MARK: - Order
struct OrderDetail: Codable {
    let orderNo, id, createdAt: String?
}


// MARK: - WalletModel
struct TransferMoneyModel: Codable {
    let code: Int?
    let message: String?
  
}



struct RelaxedString: Codable {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // attempt to decode from all JSON primitives
        if let str = try? container.decode(String.self) {
            value = str
        } else if let int = try? container.decode(Int.self) {
            value = int.description
        } else if let double = try? container.decode(Double.self) {
            value = double.description
        } else if let bool = try? container.decode(Bool.self) {
            value = bool.description
        } else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: decoder.codingPath, debugDescription: ""))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
